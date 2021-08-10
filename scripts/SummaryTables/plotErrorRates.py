"""
Marianne Bjorner
18JUN2021

This script returns false positive and false negative rates, given an alpha level, 
for MSCquartets and TICR results
"""

import os
import numpy as np
from datetime import datetime
import matplotlib.pyplot as plt


"""
Write false positives and false negatives to file at EVAL_DATA_PATH/evaluation_results.txt
:param false_positives: 1d numpy array of false positives to write
:param false_negatives: 1d numpy array of false negatives to write
"""
def write_to_file(false_positives, false_negatives):
    with open(EVAL_DATA_PATH + "evaluation_results.txt", "w") as file:
        file.write(datetime.now().strftime("%m/%d/%Y, %H:%M:%S") + "\n")
        file.write("Mean False Positives: " + str(np.mean(false_positives)) + "\n")
        file.write("Mean False Negatives: " + str(np.mean(false_negatives)) + "\n\n")
        file.write("False Positives: " + str(false_positives) + "\n")
        file.write("False Negatives: " + str(false_negatives))

"""
Plot distribution of given false positives and false negatives scores as a histogram
Save result to EVAL_DATA_PATH/eval.png
:param false_positives: 1d numpy array of false positives scores
:param false_negatives: 1d numpy array of false negatives scores
"""
def plot_line_graph(false_positives, false_negatives):
    
    number_genes = [1920,1930,1940,1950,1960,1970,1980,1990,2000,2010]
    Unemployment_Rate = [9.8,12,8,7.2,6.9,7,6.5,6.2,5.5,6.3]
 
    fig, axs = plt.subplots(1, 2, sharey=True, tight_layout=True)

    # We can set the number of bins with the `bins` kwarg
    axs[0].hist(false_positives, bins=20)
    axs[0].set_title("Mean False Positives: " + str(np.mean(false_positives))[:4])
    axs[0].set_ylabel("# of occurences")
    axs[0].set_xlabel("False Positives")
    axs[1].hist(f1, bins=20)
    axs[1].set_title("Mean False Negatives Score: " + str(np.mean(false_negatives))[:4])
    axs[1].set_xlabel("False Negatives")
    fig.savefig(EVAL_DATA_PATH + "eval.png")


"""
Run the evaluation, write resulting false positives and false negatives scores to a file and save histogram
of scores to file. 
Scores are saved to eval_data_path/evaluation_results.txt
Histogram is saved to eval_data_path/eval.png
:param ground_truth_path: path to the ground truth folders (GROUND_TRUTH_PATH global when running directly)
:param eval_data_path: path to the eval folders (EVAL_DATA_PATH global when running direcly)
"""
def evaluate(ground_truth_path, eval_data_path):
    # Get the partial paths (e.g. ??.csv) of every table in dataset
    image_paths = [] # Segmentation ground truth (_fg.png)
    for subfolder in os.listdir(ground_truth_path):
        for f in os.listdir(ground_truth_path + subfolder):
            if "_fg.png" in f:
                image_paths.append(subfolder + "/" + f)

    false_positives = []
    false_negatives = []

    for img in image_paths:
        print("eval:", img)
        # read in images as flat numpy array
        ground_truth = np.array(Image.open(ground_truth_path + "/" + img)).flatten()
        test = np.array(Image.open(eval_data_path + "/" + img)).flatten()
        # normalize value to be 0 or 1
        ground_truth = ground_truth/np.max(ground_truth)
        test = test/np.max(test)
        test[np.isnan(test)] = 0

        false_positives.append(jaccard_score(ground_truth, test))
        false_negatives.append(f1_score(ground_truth, test))

    write_to_file(false_positives, false_negatives)
    plot_histogram(false_positives, false_negatives)

    return (false_positives, false_negatives)

def main():
    evaluate(SCORES, alphas)