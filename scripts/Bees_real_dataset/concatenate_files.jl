# concatenate genetree files for Pseudapisbees_doi_10

using CSV, DataFrames

# DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/gene_trees/Iq2_GTRG
# /Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/gene_trees/Iq2_MFP
dataset_folder = "/Users/bjorner/DOI_datasets/Pseudapisbees_doi_10.5061_dryad.z08kprrb6__v4/"
folder = ARGS[1]
files_list = ARGS[2]
name_output_file = ARGS[3]

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

