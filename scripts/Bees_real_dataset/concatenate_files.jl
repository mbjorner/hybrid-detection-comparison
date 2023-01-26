# concatenate genetree files for Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4

using CSV, DataFrames

# set path to folder containing data
dataset_folder = "/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/"
folder = ARGS[1] # one of: Iq2_GTRG, Iq2_MFP, MrBayes_GTRG, MrBayes_rj, PhyloBayes, RAxML (name of subfolder)
files_list = ARGS[2]
files_list = "gene_tree_files.txt" # text file in the format of one file name each line
name_output_file = ARGS[3] # Match pattern of: ${folder}_concatenated_gene_tree_files.tre    e.g. "Iq2_GTRG_concatenated_gene_tree_files.tre"

cd(dataset_folder)
file_names = CSV.read(files_list, DataFrame)

folder = string(dataset_folder,"gene_trees/",folder,"/")
cd(folder)

io = open(name_output_file, "w")
close(io)

for row in 1:size(file_names,1)
    filename2 = file_names[row,:]
    run(`/bin/bash -c "cat $filename2 >> $name_output_file"`)

end
