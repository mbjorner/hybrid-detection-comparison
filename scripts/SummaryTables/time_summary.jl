# Marianne Bjorner
# July 28th 2022


using CSV, DataFrames

# this compiles all timing outputs, as indicated from a directory or file, and creates and outputs a CSV
# in the form:

## method ## network ## network size ## gene_trees/seq_length ## trial ## wall_time_taken (seconds) ## cpu_time_taken (seconds)

## from the string representation of time, as given by the output from
## the linux shell command "time", this will compute the time taken in seconds

# input must be in the form of:
# 920m0.027s
#
function computeTimeInSeconds(string_time::AbstractString) 
    # hours_split = split(string_time, "h")
    # hours = hours_split[1]
    inputformat = r"\s*\d*m\d*.\d*s\s*"
    t = match(inputformat, string_time)
    if t === nothing
        error("Time does not match expected input format ", string_time)
    end

    minutes_split = split(t.match, "m")
    minutes = minutes_split[1]
    seconds = parse(Float64, split(minutes_split[2], "s")[1])
    # hours_to_seconds = parse(Int64, hours) * 60 * 60
    minutes_to_seconds = parse(Float64, minutes) * 60
    
    sum_time = minutes_to_seconds + seconds

    return sum_time
end

# from the file name, extracts information in the form of
# [method, network name, network size, gene tree/seq length, trial number]
# example: n10h2.net-gt10000-11.tre_seqgen_concatenated.out_D3_D_time.txt 
# returns: [D3, n10h2.net, 10, 10000, 11]
function extractMethodDetails(filename::AbstractString)
    netname=split(filename, "-")[1]

    regex_netsize = r"n\d*"
    netsize = match(regex_netsize, netname)
    netsize = split(netsize.match, "n")[2]

    gt_number=split((split(filename, "-gt")[2]), "-")[1]
    regex_trial = r"\d*.tre"
    trial_number = match(regex_trial, filename)
    trial_number = split(trial_number.match, ".tre")[1]
    
    possible_methods = ["HyDe", "D3", "TICR", "MSC"]
    method=nothing
    for met in possible_methods
        if contains(filename, met)
            method = met
        end
    end

    return method, netname, netsize, gt_number, trial_number
end

# Some files contain extra information located at the beginning of the file,
# and times are noted in a specific format as designated 
# by the operating system used to conduct the "time" command and write the output file
# in linux, this is :
# 
# real	924m8.360s
# user	920m0.027s
# sys	3m52.979s
# 
# note that user time is equivalent to cpu time

function findTimes(filename::AbstractString)
    file_to_text=read(filename, String)
    split_by_real = split(file_to_text, "real")
    index_after_last_real = size(split_by_real, 1)
    times = split_by_real[index_after_last_real]
    real_user_sys = split(times, "user")
    real_time = real_user_sys[1]
    user_sys = split(real_user_sys[2], "sys")
    cpu_time = user_sys[1]
    # sys_time = user_sys[2]

    cpu_time = computeTimeInSeconds(cpu_time)
    wall_time = computeTimeInSeconds(real_time)

    return cpu_time, wall_time
end

"""
creates row to push to dataframe
"""
function populateTimeRow(filename::AbstractString, pathToFile::String)
    cpu_time, wall_time = findTimes(string(pathToFile, filename))
    method, netname, netsize, gt_number, trial_number = extractMethodDetails(filename)
    return method, netname, netsize, gt_number, trial_number, wall_time, cpu_time
end

savePath="/Users/bjorner/GitHub/phylo-microbes/output/ms_out/" # will save in current directory unless otherwise specified
outfile_name="time_summary.csv"

# conduct batch analysis from list of input files, saved as a separate text file
list_output_files = Vector(CSV.File("/Users/bjorner/GitHub/phylo-microbes/output/ms_out/files_to_analyze_time.txt", header=false))

# create dataframe to save 
column_names = [:method, :netname, :netsize, :gt_number, :trial_number, :wall_time, :cpu_time]
# add all names to dataframe as empty columns
df_results = DataFrame(column_names .=> Ref([]))

for file in list_output_files
    file = string(file[1])
    if contains(file, "time.txt")
        print(file)
        row = populateTimeRow(file, string(savePath,"output/"))
        push!(df_results, row)
    end
end

CSV.write(string(savePath, outfile_name), df_results)
