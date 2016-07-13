#!/usr/bin/env ruby
#
#  Utility to automatically commit all changes to dotfiles.
#
#  This script manages a branch named after the hostname of the current machine.
#  When ran, it adds a commit for each file that was added, modified or removed.
#
#  TODO:
#  - Add checks for branch
#  - Handle renames/copies

require 'fileutils'
require 'shellwords'

def commit(filename, message)
    `git add #{Shellwords.escape(filename)}`
    `git commit -m #{Shellwords.escape("auto: #{message}")}`
end

FileUtils.cd File.dirname(__FILE__) do
    `git reset`

    `git status --porcelain`.each_line do |line|
        filename = line[3..-2]

        case line
        when /^ M/, /^MM/
            added, deleted = `git diff --numstat #{Shellwords.escape(filename)}`.split("\t")[0..1].map(&:to_i)
            commit filename, "Modified +#{added} -#{deleted} in #{filename}"
        when /^ A/, /^A./, /^\?\?/
            commit filename, "Added #{filename}"
        when /^ D/, /^D./
            commit filename, "Deleted #{filename}"
        end
    end

    `git push`
end
