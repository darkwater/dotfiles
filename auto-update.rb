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
    puts "committing #{filename}"

    `git add #{Shellwords.escape(filename)}`
    exit $?.exitstatus unless $?.success?

    `git commit -m #{Shellwords.escape("auto: #{message}")}`
    exit $?.exitstatus unless $?.success?
end

FileUtils.cd File.dirname(__FILE__) do
    puts "resetting"
    `git reset`
    exit $?.exitstatus unless $?.success?

    puts "pulling"
    `git pull`
    exit $?.exitstatus unless $?.success?

    `git status --porcelain`.each_line do |line|
        filename = line[3..-2]

        case line
        when /^ M/, /^MM/
            added, deleted = `git diff --numstat #{Shellwords.escape(filename)}`.split("\t")[0..1].map(&:to_i)
            commit filename, "modified +#{added} -#{deleted} in #{filename}"
        when /^ A/, /^A./, /^\?\?/
            commit filename, "added #{filename}"
        when /^ D/, /^D./
            commit filename, "deleted #{filename}"
        end
    end

    puts "pushing"
    `git push -q`
    exit $?.exitstatus unless $?.success?
end
