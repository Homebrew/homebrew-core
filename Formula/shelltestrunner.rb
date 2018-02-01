require "language/haskell"

class Shelltestrunner < Formula
  include Language::Haskell::Cabal

  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.9/shelltestrunner-1.9.tar.gz"
  sha256 "cbc4358d447e32babe4572cda0d530c648cc4c67805f9f88002999c717feb3a8"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    (testpath/"test").write "$$$ {exe} {in}\n>>> /{out}/\n>>>= 0"
    args = "-D{exe}=echo -D{in}=message -D{out}=message -D{doNotExist}=null"
    assert_match "Passed", shell_output("#{bin}/shelltest #{args} test")
  end
end
