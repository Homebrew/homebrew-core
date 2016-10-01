class Xstow < Formula
  desc "Extended replacement for GNU Stow"
  homepage "http://xstow.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xstow/xstow-1.0.2.tar.bz2"
  sha256 "6f041f19a5d71667f6a9436d56f5a50646b6b8c055ef5ae0813dcecb35a3c6ef"

  bottle do
    sha256 "cbc066f33e9634a4a41e4288e8da74bafd2f7ea81952a72ebdf1227e9c1e3f8d" => :sierra
    sha256 "831ebc6209e25a8c85de9049ac3c7ff9c92155b3d23f792f9c768b963085cbb5" => :el_capitan
    sha256 "5584a4365068160f539ce883bb261b8a82f6be56331ea8abf55bc611126ea71b" => :yosemite
    sha256 "f8b4bd43dce5410280683721e4bbff8419a671f6764215d20bc4d17eddc00863" => :mavericks
  end

  fails_with :clang do
    cause <<-EOS.undent
      clang does not support unqualified lookups in c++ templates, see:
      http://clang.llvm.org/compatibility.html#dep_lookup
      EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--disable-static", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/xstow", "-Version"
  end
end
