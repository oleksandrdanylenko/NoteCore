#!/usr/bin/env bash

#exit if any command fails
set -e

artifactsFolder="./artifacts"

if [ -d $artifactsFolder ]; then
  rm -R $artifactsFolder
fi

dotnet restore

# Ideally we would use the 'dotnet test' command to test netcoreapp and net451 so restrict for now 
# but this currently doesn't work due to https://github.com/dotnet/cli/issues/3073 so restrict to netcoreapp

dotnet test ./NotesCore/NoteTests/ -c Release -f netcoreapp2.1

# Instead, run directly with mono for the full .net version 
dotnet build ./NotesCore/NoteTests/ -c Release -f net451

mono \
./NotesCore/NoteTests/bin/Release/net451/*/NoteTests.exe \
./NotesCore/NoteTests/bin/Release/net451/*/NoteTests.dll

revision=${TRAVIS_JOB_ID:=1}
revision=$(printf "%04d" $revision) 

dotnet pack ./NotesCore -c Release -o ./artifacts --version-suffix=$revision