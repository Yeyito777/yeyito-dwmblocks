#ifndef CONFIG_H
#define CONFIG_H

// String used to delimit block outputs in the status.
#define DELIMITER " | "

// Maximum number of Unicode characters that a block can output.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Control whether blocks are clickable.
#define CLICKABLE_BLOCKS 0

// Control whether a leading delimiter should be prepended to the status.
#define LEADING_DELIMITER 0

// Control whether a trailing delimiter should be appended to the status.
#define TRAILING_DELIMITER 0

// Define blocks for the status feed as X(icon, cmd, interval, signal).
//   interval: seconds between auto-updates (0 = signal-only)
//   signal:   unique ID for on-demand update via pkill -RTMIN+N dwmblocks
#define BLOCKS(X)                    \
    X("",      "sb-stopwatch", 1, 7) \
    X("",      "sb-timer",   1, 5)   \
    X("CPU: ", "sb-cpu",     1, 1)   \
    X("MEM: ", "sb-mem",     1, 2)   \
    X("SWP: ", "sb-swp",     1, 3)   \
    X("GPU: ", "sb-gpu",     2, 4)   \
    X("BAT: ", "sb-bat",    30, 6)

#endif  // CONFIG_H
