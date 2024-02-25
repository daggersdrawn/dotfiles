#!/usr/bin/python

import subprocess
import json
import time
from datetime import datetime
import argparse
import os
import re


# Define command line arguments
def get_args():
    parser = argparse.ArgumentParser(description="Get notification history from dunst")
    parser.add_argument("-s", "--summary-size", help="Maximum size for notification summary to be displayed", type=int, default=16)
    parser.add_argument("-f", "--from", help="Show only results from given sender (summary contains given string)", type=str, dest="sender")
    parser.add_argument("-t", "--time-format", help="Use custom time format", type=str, default="%H:%M")
    parser.add_argument("-T", "--no-time", help="Don't show time of notification", action="store_true")
    return parser.parse_args()

# Return list of notifications
def get_history():
    # Get notification history from dunst
    history_stdout = subprocess.run(["dunstctl", "history"], stdout = subprocess.PIPE,
                    universal_newlines = True).stdout
    hst_json = json.loads(history_stdout)

    # Make sure notifications are chronologically sorted
    return sorted(hst_json['data'][0], key=lambda x: x['timestamp']['data'])


# Extend or shorten string to have a given length
def fixed_len(s, size):
    if len(s) > size:
        return s[:size]
    else:
        return s.ljust(size)


# Format string so that it is align to pad size and doesnt wrap around screen
def align(data, pad, window_size):
    ret = ""
    fmt = "(.{%d})" % (window_size - pad)

    for line in data.split("\n"):
        ret += re.sub(fmt, "\\1\n", line)
        ret += "\n"

    return ret[:-1].replace("\n", "\n" + pad * " ")


# Print notification to stdout
def print_notif(notif, based, summary_size, time_format, window_size):
    summary = fixed_len(notif['summary']['data'], summary_size)

    if "This site has been updated in the background." in notif['body']['data']:
        return
    if notif['body']['data'].startswith('<a href'):
        notif['body']['data'] = notif['body']['data'][58:]

    if time_format != "":
        ts_mono = notif['timestamp']['data'] / 1000000
        ts_str = datetime.utcfromtimestamp(based + ts_mono).strftime(time_format)

        # Calculate number of spaces needed to align to new line
        pad = len(ts_str) + summary_size + 4

        # body = notif['body']['data'].replace("\n", "\n" + pad * " ")
        body = align(notif['body']['data'], pad, window_size)
        print("{} {} - {}".format(ts_str, summary, body))

    else:
        body = notif['body']['data'].replace("\n", "\n" + (summary_size) * " ")
        print("{} - {}".format(summary, body))


if __name__ == "__main__":
    args = get_args()
    notif_list = get_history()

    # Calculate monotonic time origin (what does monotonic 0 correspond to in UNIX time)
    based = time.time() - time.monotonic()

    # Generate final time format
    if args.no_time:
        t_format = ""
    else:
        t_format = args.time_format

    # Get terminal window size
    window_size = os.get_terminal_size().columns

    # Prints every notification in list (tho possibly filtered)
    for n in notif_list:
        if not args.sender is None and not args.sender in n['summary']['data']:
            continue
        print_notif(n, based, args.summary_size, t_format, window_size)

