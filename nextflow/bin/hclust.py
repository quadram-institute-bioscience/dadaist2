#!/usr/bin/env python
"""
USAGE: transpose.py [options] Table.tsv

INPUT (percentages, but this is not assumed):
Family                  NHP6    NHP18   NHP15   NHP11   All
"Prevotellaceae"        19.5    0.0106  58.4    41.4    24.4
(Unassigned)            14.1    3.69    5.64    11.4    21.5
Ruminococcaceae         14.8    0       7.33    12      15.2
Lachnospiraceae         31      0.201   11.7    14.5    14.6
Veillonellaceae         5.16    0.0053  3.77    7.02    4.0
"Porphyromonadaceae"    0.469   18.6    0.587   0.6     2.6

Import a TSV table (taxonomy summary by USEARCH), having samples in columns and OTU/ASVs in rows
 - use first column as index key (feature name), 
 - remove rows where the sum is below a threshold,
 - transpose (samples as rows)
 - sort rows by names (sample name)

 
"""
import numpy as np
import pandas
import sys
import argparse
#from IPython import embed
import matplotlib.pyplot as plt
import matplotlib
from scipy.cluster.hierarchy import dendrogram, linkage

def heatmap(data, row_labels, col_labels, ax=None,
            cbar_kw={}, cbarlabel="", **kwargs):
    """
    Create a heatmap from a numpy array and two lists of labels.

    Parameters
    ----------
    data
        A 2D numpy array of shape (N, M).
    row_labels
        A list or array of length N with the labels for the rows.
    col_labels
        A list or array of length M with the labels for the columns.
    ax
        A `matplotlib.axes.Axes` instance to which the heatmap is plotted.  If
        not provided, use current axes or create a new one.  Optional.
    cbar_kw
        A dictionary with arguments to `matplotlib.Figure.colorbar`.  Optional.
    cbarlabel
        The label for the colorbar.  Optional.
    **kwargs
        All other arguments are forwarded to `imshow`.
    """

    if not ax:
        ax = plt.gca()

    # Plot the heatmap
    im = ax.imshow(data, **kwargs)

    # Create colorbar
    cbar = ax.figure.colorbar(im, ax=ax, **cbar_kw)
    cbar.ax.set_ylabel(cbarlabel, rotation=-90, va="bottom")

    # We want to show all ticks...
    ax.set_xticks(np.arange(data.shape[1]))
    ax.set_yticks(np.arange(data.shape[0]))
    # ... and label them with the respective list entries.
    ax.set_xticklabels(col_labels)
    ax.set_yticklabels(row_labels)

    # Let the horizontal axes labeling appear on top.
    ax.tick_params(top=True, bottom=False,
                   labeltop=True, labelbottom=False)

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=-30, ha="right",
             rotation_mode="anchor")

    # Turn spines off and create white grid.
    for edge, spine in ax.spines.items():
        spine.set_visible(False)

    ax.set_xticks(np.arange(data.shape[1]+1)-.5, minor=True)
    ax.set_yticks(np.arange(data.shape[0]+1)-.5, minor=True)
    ax.grid(which="minor", color="w", linestyle='-', linewidth=3)
    ax.tick_params(which="minor", bottom=False, left=False)

    return im, cbar


def annotate_heatmap(im, data=None, valfmt="{x:.2f}",
                     textcolors=["black", "white"],
                     threshold=None, **textkw):
    """
    A function to annotate a heatmap.

    Parameters
    ----------
    im
        The AxesImage to be labeled.
    data
        Data used to annotate.  If None, the image's data is used.  Optional.
    valfmt
        The format of the annotations inside the heatmap.  This should either
        use the string format method, e.g. "$ {x:.2f}", or be a
        `matplotlib.ticker.Formatter`.  Optional.
    textcolors
        A list or array of two color specifications.  The first is used for
        values below a threshold, the second for those above.  Optional.
    threshold
        Value in data units according to which the colors from textcolors are
        applied.  If None (the default) uses the middle of the colormap as
        separation.  Optional.
    **kwargs
        All other arguments are forwarded to each call to `text` used to create
        the text labels.
    """

    if not isinstance(data, (list, np.ndarray)):
        data = im.get_array()

    # Normalize the threshold to the images color range.
    if threshold is not None:
        threshold = im.norm(threshold)
    else:
        threshold = im.norm(data.max())/2.

    # Set default alignment to center, but allow it to be
    # overwritten by textkw.
    kw = dict(horizontalalignment="center",
              verticalalignment="center")
    kw.update(textkw)

    # Get the formatter in case a string is supplied
    if isinstance(valfmt, str):
        valfmt = matplotlib.ticker.StrMethodFormatter(valfmt)

    # Loop over the data and create a `Text` for each "pixel".
    # Change the text's color depending on the data.
    texts = []
    for i in range(data.shape[0]):
        for j in range(data.shape[1]):
            kw.update(color=textcolors[int(im.norm(data[i, j]) > threshold)])
            text = im.axes.text(j, i, valfmt(data[i, j], None), **kw)
            texts.append(text)

    return texts


def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

if __name__ == "__main__":

  parser = argparse.ArgumentParser(description='Transpose table for MultiQC') 
  parser.add_argument('TABLE',  help='Input file name')
  parser.add_argument('-o', "--output",  help='Output file name', default="plot.png")
  parser.add_argument('-w', "--width",  help='Plot width (inches)', default=9)
  parser.add_argument("--height",  help='Plot height (inches)', default=5)
  args = parser.parse_args()

  try:
    # Import TSV, use first column as index, remove column "All"
    # note: To set rownames posteriori: set_index(list(table)[0]), or by name set_index('Column_name')
    table = pandas.read_csv(args.TABLE,delimiter='\t',encoding='utf-8', index_col=0)
    eprint(f" * Imported {args.TABLE}: {table.shape}")
  except Exception as e:
    eprint(f"Error trying to import {args.TABLE}:\n{e}")
    exit()

  try:
    plt.figure(figsize=(float(args.width), float(args.height)))
    plt.xticks(rotation=90)
    linked = linkage(table.transpose(), 'single') 
    labels = table.keys().tolist()
    dendrogram(linked,
              orientation='left',
              distance_sort='descending',
              show_leaf_counts=True,
              labels=labels,
              leaf_rotation=0,
              truncate_mode='level',
              leaf_font_size=8)
    plt.tight_layout()
    plt.savefig(args.output + '_dendrogram.png', bbox_inches='tight')
  except Exception as errorMessage:
    eprint(f"Error generating dendrogram:\n{errorMessage}")

  try:
    plt.clf()
    plt.figure(figsize=(40, 20))
    fig, ax = plt.subplots()
    im, cbar = heatmap(table.transpose(), table.columns.values, table.index.values, ax=ax,
                   cmap="YlGn", cbarlabel="xxx")

    texts = annotate_heatmap(im, valfmt="{x:.1f}")

    fig.tight_layout()
    plt.show()
    plt.savefig(args.output + '_heatmap.png')

  except Exception as errorMessage:
    eprint(f"Skipping heatmap:\n{errorMessage}")
