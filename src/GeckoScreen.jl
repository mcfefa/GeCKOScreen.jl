module GeckoScreen

using DataFrames
using CSV
using Query
using Statistics
using Dates

export readGeCKOlibrary, createScreenDF


"""    readGeCKOlibrary()

Creates a DataFrame of the GeCKO libraries. Created from CSV file of sequences belonging to "Human CRISPR Knockout Pooled LIbrary (GeCKO v2): can be found: https://www.addgene.org/pooled-library/zhang-human-gecko-v2/. 

"""
function readGeCKOlibrary()
  
  ## These library files have 3 columns, 1 with the gene name, one with the UIDs, and the thirds has the specific sequences
  fields = ["","",""]
  collectedFields = ["","",""]; 
  for line in eachline("human_geckov2_library_a_09mar2015_v2.csv")
      fields = split(line, ",")
      collectedFields = hcat(collectedFields, fields)
  end

  genes = collectedFields[1,3:end];
  UIDs = collectedFields[2,3:end];
  seqs = collectedFields[3,3:end]; 

  ## Create DataFrame with first half of sequences
  af = DataFrame(gene=genes, UID=UIDs, seq=seqs);

  fieldsB = ["","",""]
  collectedFieldsB = ["","",""]; 
  for line in eachline("human_geckov2_library_b_09mar2015_v2.csv")
      fieldsB = split(line, ",")
      collectedFieldsB = hcat(collectedFieldsB, fieldsB)
  end

  genesB = collectedFieldsB[1,3:end];
  UIDsB = collectedFieldsB[2,3:end];
  seqsB = collectedFieldsB[3,3:end]; 

  ## Create DataFrame with second half of sequences
  bf = DataFrame(gene=genesB, UID=UIDsB, seq=seqsB);

  ## Combine all sequences into same DataFrame and make sure :seq is the correct type
  gmap = append!(af,bf)
  gmap[:seq] = convert(Array{Union{Missing, String},1}, gmap[:seq]) Array{AbstractString,1}

  return gmap

end

### create same function that will load libraries if given a file

struct RNAScreen
  drug::String
  day::Int
  replicate::Int
  path::String
end


function createScreenDF(files)

  for rnas in files
      df = CSV.read(rnas.path, header=[:rna, :count])
      df[:drug] = rnas.drug
      df[:day] = rnas.day
      df[:replicate] = rnas.replicate
      CSV.write(string("RNAScreens_RIGER_",Dates.today(),".csv"), df, append=true)
  end

  df = CSV.read(string("RNAScreens_RIGER_",Dates.today(),".csv"), header=[:rna, :count, :drug, :day, :replicate])
  
  return df

end
