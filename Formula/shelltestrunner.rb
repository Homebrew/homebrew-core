require "language/haskell"

class Shelltestrunner < Formula
  include Language::Haskell::Cabal

  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.9/shelltestrunner-1.9.tar.gz"
  sha256 "cbc4358d447e32babe4572cda0d530c648cc4c67805f9f88002999c717feb3a8"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6c941fb8a8b18e51789a9523fab1d1e8ab312d6c0ce93af72f2caf495a54870" => :high_sierra
    sha256 "3ddd0cf1e9baf4f31e667bb1477af3e7a7b905071041569bb1bd6031118a377b" => :sierra
    sha256 "2f954da156e2d7aea6059738913124883a78797d1118ba11b8366bc4b7dd03dd" => :el_capitan
  end

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
