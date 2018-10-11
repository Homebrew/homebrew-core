class Terminus < Formula
  desc "Standalone utility for performing operations on the Pantheon Platform"
  homepage "https://github.com/pantheon-systems/terminus"
  url "https://github.com/pantheon-systems/terminus/archive/1.9.0.tar.gz"
  sha256 "4e315e950affbf0c95e7b1225b80151c85ff8ae04b2aad053c2adb5c30380f93"

  depends_on "Composer"

  def install
    system "composer", "install"
    bin.install "bin/terminus" => "terminus"
    prefix.install Dir["*"]
  end

  test do
    system bin/"terminus", "self:info", "--field=terminus_version"
  end
end
