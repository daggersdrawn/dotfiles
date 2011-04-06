# -*- coding: utf-8 -*-

"""
License

@author : yinwm <yinweiming@gmail.com>
"""

import os
import ConfigParser


from mercurial import commands
from mercurial import hg

from mercurial.i18n import _

BASIC_SECTION = 'Basic'
SECNAME_PUBLISH_BRANCH          = 'publish'
SECNAME_DEVELOP_BRANCH          = 'develop'
SECNAME_FEATURE_PREFIX          = 'feature'
SECNAME_RELEASE_PREFIX          = 'release'
SECNAME_HOTFIX_PREFIX           = 'hotfix'
SECNAME_VERSION_TAG_PREFIX      = 'version_tag'

class HgFlow(object):

    def __init__(self, ui, repo):
        self.ui = ui
        self.repo = repo

        self.rootDir = self.repo.root
        self.cfgFile = os.path.join(self.rootDir, '.hgflow')
        self.inited  = os.path.exists(self.cfgFile)

        if self.inited:
            config = ConfigParser.ConfigParser()
            config.read(self.cfgFile)

            self.publishBranch = config.get(BASIC_SECTION, SECNAME_PUBLISH_BRANCH)
            self.developBranch = config.get(BASIC_SECTION, SECNAME_DEVELOP_BRANCH)
            self.featurePrefix = config.get(BASIC_SECTION, SECNAME_FEATURE_PREFIX)
            self.releasePrefix = config.get(BASIC_SECTION, SECNAME_RELEASE_PREFIX)
            self.hotfixPrefix = config.get(BASIC_SECTION, SECNAME_HOTFIX_PREFIX)
            self.versionTagPrefix = config.get(BASIC_SECTION, SECNAME_VERSION_TAG_PREFIX)

        #self.output(self.rootDir, '\n', self.cfgFile, '\n', self.inited, '\n')

    def output(self, *args):
        for v in args:
            self.ui.write(v)

    def outputln(self, *args):
        args = args + ('\n',)
        self.output(*args)


    def input(self, msg):
        self.output(msg)
        return raw_input().strip()

    def _getBranches(self):
        bmap = self.repo.branchmap()
        branches = []
        for b, h in bmap.iteritems():
            branches.append(b)

        return branches

    def _checkInited(self):
        if not self.inited:
            self.output(_('Your workspace is not inited with hg flow, use `hg flow init first`.'), '\n')
            return False

        return True


    def _hasUncommit(self):
        status = self.repo.status()
        for l in status:
            if len(l) > 0:
                self.outputln(_('Your workspace has uncommit content.'))
                return True

        return False


    def _createBranch(self, branch_name, message, from_branch = None):
        if not from_branch is None:
            #first update to from_branch
            commands.update(self.ui, self.repo, from_branch)

        commands.branch(self.ui, self.repo, branch_name)
        commands.commit(self.ui, self.repo, message = message)


    def hgflow_func_init(self, args, opts):
        if self.inited:
            self.output(_('Your workspace is already inited, use `hg flow check` for detail hg flow information'), '\n')
            return

        branches = self._getBranches()

        ctx = self.repo[None]
        current_branch = str(ctx.branch())


        if len(branches) > 1:
            #more than one brnach, give a warn
            self.output(_('You have more than one branches:'), '\n')
            for b in branches:
                self.output(b, '\t')
                if b != current_branch:
                    self.output('(inactive)')
                self.outputln()

            text = self.input(_('You want to continue flow init? [y] '))
            if not ('' == text or 'y' == text or 'yes' == text):
                return

        if self._hasUncommit():
            return

        publish_branch          = 'default'
        develop_branch          = 'develop'
        feature_branch_prefix   = 'feature/'
        release_branch_prefix   = 'release/'
        hotfix_branch_prefix    = 'hotfix/'
        version_tag_prefix      = ''

        text = self.input(_('Branch name for production release : [default] '))
        if text: publish_branch = text

        text = self.input(_('Branch name for "next release" development : [develop] '))
        if text: develop_branch = text

        self.output('\n', _('How to name your supporting branch prefixes?'), '\n');

        text = self.input(_('Feature branches? [feature/] '))
        if text: feature_branch_prefix = text
        text = self.input(_('Release branches? [release/] '))
        if text: release_branch_prefix = text
        text = self.input(_('Hotfix branches? [hotfix/] '))
        if text: hotfix_branch_prefix = text
        text = self.input(_('Version tag prefix? [] '))
        if text: version_tag_prefix = text

        #check existing branch

        import ConfigParser
        config = ConfigParser.RawConfigParser()

        config.add_section(BASIC_SECTION)
        config.set(BASIC_SECTION, SECNAME_PUBLISH_BRANCH,       publish_branch)
        config.set(BASIC_SECTION, SECNAME_DEVELOP_BRANCH,       develop_branch)
        config.set(BASIC_SECTION, SECNAME_FEATURE_PREFIX,       feature_branch_prefix)
        config.set(BASIC_SECTION, SECNAME_RELEASE_PREFIX,       release_branch_prefix)
        config.set(BASIC_SECTION, SECNAME_HOTFIX_PREFIX,        hotfix_branch_prefix)
        config.set(BASIC_SECTION, SECNAME_VERSION_TAG_PREFIX,   version_tag_prefix)

        with open(self.cfgFile, 'wb') as configfile:
            config.write(configfile)

        commands.add(self.ui, self.repo, self.cfgFile)
        commands.commit(self.ui, self.repo, self.cfgFile, message="hg flow init, add .hgflow file")

        if not publish_branch in branches:
            #create publish_branch
            self._createBranch(publish_branch, 'hg flow init, add branch %s' % (publish_branch, ))

        if not develop_branch in branches:
            self._createBranch(develop_branch, 'hg flow init, add branch %s' % (develop_branch, ))

    def _startBranch(self, target_branch, branch_type):
        branches = self._getBranches()
        if target_branch in branches:
            self.outputln(_('Already has branch named `%s`' % (target_branch, )))
            return

        self._createBranch(target_branch, 'hg flow, add %s branch `%s`.' % (branch_type, target_branch, ), 'develop')

    def _findBranch(self, target_branch, name):
        branches = self._getBranches()
        if not target_branch in branches:
            self.outputln(_('No such feature named `%s`' % (name,)))
            return False

        return True


    def hgflow_func_feature(self, args, opts):
        def _feature_func(action, name, target_branch):
            if 'start' == action:
                self._startBranch(target_branch, 'feature')

            elif 'finish' == action:
                '''finish this feature.
                1, Check develop branch version and current feature
                1, Close this branch
                2, Merge it into develop
                3, Commit develop branch
                '''

                if not self._findBranch(target_branch, name):
                    return

                commands.update(self.ui, self.repo, target_branch)
                commands.commit(self.ui, self.repo, close_branch=True, message='hg flow, close feature %s' % (name,))

                commands.update(self.ui, self.repo, self.developBranch)
                commands.merge(self.ui, self.repo, target_branch)
                #commands.commit(self.ui, self.repo, message='hg flow, merge feature `%s` to develop branch `%s`' % (target_branch, self.developBranch))
                commands.commit(self.ui, self.repo, message='hg flow, merge release `%s` to develop branch `%s`' % (name, self.developBranch))
                #self.outputln(_('WARNING: No automatic commit after merge from feature `%s`, you should resolve the confict (if any) then commit manually.' % (name,)))

            elif 'change' == action:
                commands.update(self.ui, self.repo, target_branch)
                """
            elif 'fetchdev' == action:
                pass
            """
            else:
                self.outputln(_('Please give a valid action.'))

        self._hgflow_func_base(args, opts, self.featurePrefix, _feature_func)


    def _hgflow_func_base(self, args, opts, prefix, func):
        if not self._checkInited():
            return

        if len(args) < 2:
            self.outputln(_('Please give a full command.'))
            return

        if self._hasUncommit():
            return


        action = args[0]
        name = args[1]
        target_branch = '%s%s' % (prefix, name)

        func(action, name, target_branch)

    def hgflow_func_release(self, args, opts):
        def _release_func(action, name, target_branch):
            if 'start' == action:
                '''Create release branch from develop branch
                '''
                self._startBranch(target_branch, self.developBranch)
            elif 'finish' == action:
                '''finish this release
                1, Check publish branch version and current version
                2, Close this branch
                3, Merge it into publish branch
                4, Tag publish branch with release branch name
                5, Merge it into develop branch. Always not successed, should manully do that
                '''

                if not self._findBranch(target_branch, name):
                    return

                self._mergeIntoPublishBranch(target_branch, name)

            else:
                self.outputln(_('Please give a valid action.'))

        self._hgflow_func_base(args, opts, self.releasePrefix, _release_func)

    def hgflow_func_hotfix(self, args, opts):
        def _hotfix_func(action, name, target_branch):
            if 'start' == action:
                '''Create hotfix branch from publish branch
                '''
                self._startBranch(target_branch, self.publishBranch)
            elif 'finish' == action:
                '''finish the hotfix
                1, Check publish branch version and current version
                2, Close this branch
                3, Merge it into publich branch
                4, Tag publish branch with hotfix branch name
                5, Merge it into develop branch. Always not successed, otherwise should manually do that
                '''

                if not self._findBranch(target_branch, name):
                    return

                self._mergeIntoPublishBranch(target_branch, name)

            else:
                self.outputln(_('Please give a valid action.'))

        self._hgflow_func_base(args, opts, self.hotfixPrefix, _hotfix_func)

    def _mergeIntoPublishBranch(self, target_branch, name):
        commands.update(self.ui, self.repo, target_branch)
        commands.commit(self.ui, self.repo, close_branch=True, message='hg flow, close release %s' % (target_branch,))
        commands.update(self.ui, self.repo, self.publishBranch)

        commands.merge(self.ui, self.repo, target_branch)
        commands.commit(self.ui, self.repo, close_branch=True, message='hg flow, merge release `%s` to publish branch `%s`' % (name, self.publishBranch))

        tag_name = '%s%s' % (self.versionTagPrefix, name)
        commands.tag(self.ui, self.repo, tag_name)

        #merge it into develop branch, there should be many confilct code
        commands.update(self.ui, self.repo, self.developBranch)
        commands.merge(self.ui, self.repo, self.publishBranch)

        commands.commit(self.ui, self.repo, message='hg flow, merge release `%s` to develop branch `%s`' % (name, self.developBranch))

        #self.outputln(_('WARNING: No automatic commit after merge from release `%s`, you should resolve the confict (if any) then commit manually' % (name, )))




HGFLOW_FUNCTIONS = {
    'init'      : HgFlow.hgflow_func_init,
    'feature'   : HgFlow.hgflow_func_feature,
    'release'   : HgFlow.hgflow_func_release,
    'hotfix'    : HgFlow.hgflow_func_hotfix,
    }


def hgflow_cmd(ui, repo, patch, *args, **opts):
    if patch in HGFLOW_FUNCTIONS:
        hf = HgFlow(ui, repo)
        HGFLOW_FUNCTIONS[patch](hf, args, opts)
    else:
        ui.write(_('Invalid command, use `hg flow --help` for detail information' ), '\n')

    '''
    print ui
    print repo
    print patch
    print args
    print opts
    '''



cmdtable = {
    'flow' : (
                (
                hgflow_cmd,
                [],
                ('hg flow ')
                )
        )
    }
