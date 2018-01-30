require "language/haskell"

class Shelltestrunner < Formula
  include Language::Haskell::Cabal

  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://github.com/simonmichael/shelltestrunner/archive/1.9.tar.gz"
  sha256 "066b0f41ee180cf4acc548cdb26034b6cda0c6c81b22f608b0c3f0a93bfcd9c9"

  bottle do
    sha256 "58d77951c7c82d120f496a991d0bb5277a0c7c3974bb525f30c9a26ac5a677bb" => :sierra
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/shelltest", "--version"
  end
end
