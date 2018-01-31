require "language/haskell"

class Shelltestrunner < Formula
  include Language::Haskell::Cabal

  desc "Portable command-line tool for testing command-line programs"
  homepage "https://github.com/simonmichael/shelltestrunner"
  url "https://hackage.haskell.org/package/shelltestrunner-1.9/shelltestrunner-1.9.tar.gz"
  sha256 "066b0f41ee180cf4acc548cdb26034b6cda0c6c81b22f608b0c3f0a93bfcd9c9"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    (testpath/"shelltestrunner.test").write("$$$ {exe} {in}\n>>> /{out}/\n>>>= 0")

    system "#{bin}/shelltest", "-D{exe}=echo", "-D{in}=My message", "-D{out}=My message", "-D{doNotExist}=null", "shelltestrunner.test"
  end
end
