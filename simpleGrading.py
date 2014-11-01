#!/usr/bin/env python3

"""Utility for computing a cell dimension in a simple-graded mesh.

Given the cell index j, the number of cells n in the block, the length l of the
block, and the simple grading factor g of the block, this utility computes the
size of the cell in the direction of the grading factor.

Examples:

For a block with 189 cells, a length of 4.1, and a simple grading factor of 2,
the first (smallest) cell has a size of

>>> dx(1, 189, 4.1, 2)
0.015033349748425299

The last (largest) cell has a size of
>>> dx(189, 189, 4.1, 2)
0.03006669949685053

"""

import argparse
import sys


def main():
    """Read in the command-line arguments and call dx."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument('j', type=int, help='cell index')
    parser.add_argument('n', type=int, help='number of cells in the block')
    parser.add_argument('l', type=float, help='block length')
    parser.add_argument('g', type=float, help='simple grading factor')

    args = parser.parse_args()
    print(dx(args.j, args.n, args.l, args.g))



def dx(j, n, l, g):
    """Compute the cell size from the given parameters."""
    # Check for valid inputs.
    if n < 2:
        raise ValueError('n = {} must be at least 2.'.format(n))
    if j < 1 or j > n:
        raise ValueError('j = {} must be in the range [1, n = {}]'.format(j, n))
    if l <= 0:
        raise ValueError('l = {} must be positive.'.format(l))
    if g <= 0:
        raise ValueError('g = {} must be positive.'.format(g))

    if g == 1:
        return l / n
    else:
        q = g ** (1 / (n - 1))
        return l * (1 - q) / (1 - q ** n) * q ** (j - 1)


if __name__ == '__main__':
    main()
