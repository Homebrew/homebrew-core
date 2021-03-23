require "language/node"

class Zli < Formula
  desc "BastionZero cli"
  homepage "https://www.bastionzero.com"
  url "https://github.com/bastionzero/zli/releases/download/4.9.0/zli-4.9.0.tar.gz"
  sha256 "553b7a82a1b4b5015acc9bbe645afcca1fb351e92dbfe6514d7355e8df145136"
  license "Apache-2.0"
  head "https://github.com/bastionzero/zli.git"

  bottle :unneeded
  depends_on "node@12"

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "release"
    rm "./bin/zli-win.exe"
    rm "./bin/zli-linux"
    mv "./bin/zli-macos", "./bin/zli"
    bin.install "./bin/zli"
  end

  test do
    system "zli", "help"
  end
end
