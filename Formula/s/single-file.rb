require "language/node"

class SingleFile < Formula
  desc "CLI tool for saving a faithful copy of a complete web page in a single HTML file"
  homepage "https://github.com/gildas-lormeau/single-file-cli/blob/master/README.MD"
  url "https://github.com/gildas-lormeau/single-file-cli/archive/refs/tags/v2.0.29.tar.gz"
  sha256 "bb12b99dbef208c62cd7733cbbf0930f4d088fc2bcad8fc459142a375c5a9eaa"
  license "AGPL-3.0-or-later"
  
  depends_on "node"

  def install
      system "npm", "install", *Language::Node.std_npm_install_args(libexec)
      bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
