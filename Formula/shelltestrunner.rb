require "language/haskell"

class Shelltestrunner < Formula
  include Language::Haskell::Cabal

  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.9/shelltestrunner-1.9.tar.gz"
  sha256 "cbc4358d447e32babe4572cda0d530c648cc4c67805f9f88002999c717feb3a8"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "330c8aeff49dc1901a460586c90ce7540ad33451a4fa94ec4917ad2959780adc" => :catalina
    sha256 "f1f921cc6c8fd64b1b99f483e47f1f06c4b8a39f74a823ac96df22cef9d5cf34" => :mojave
    sha256 "f494b35cab29e3a942562230b461c44a8274f7564e8863400fdf68176f3b292d" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    (testpath/"test").write "$$$ {exe} {in}\n>>> /{out}/\n>>>= 0"
    args = "-D{exe}=echo -D{in}=message -D{out}=message -D{doNotExist}=null"
    assert_match "Passed", shell_output("#{bin}/shelltest #{args} test")
  end
end
