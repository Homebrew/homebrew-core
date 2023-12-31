class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "https://oldmanprogrammer.net/source.php?dir=projects/tree"
  url "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.1.1.tar.gz"
  sha256 "1b70253994dca48a59d6ed99390132f4d55c486bf0658468f8520e7e63666a06"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d1c490c83719c983ec360085e9d0049418ff424259bc00122869f8acf68ed63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13b597dcee0eec0e8d3a7f864dfb5713d812605092bf1e417c765e788d0c0d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bd195b460f491c6e71b0277efb3c4cdbab8b6d814072519ade39e5ca257b048"
    sha256 cellar: :any_skip_relocation, sonoma:         "af3d14eb91e4bf756bb5ef5f6a489aeb33e6cf5fc4f72c99d70352bec364e282"
    sha256 cellar: :any_skip_relocation, ventura:        "da304661d82c58ee3d4a14f80479d15d3405ca4c1be78b6085f7c62e67f79412"
    sha256 cellar: :any_skip_relocation, monterey:       "13a0875d7da74de5ccfd1c6d3bd6167d2c4c0d7d4d747cc3ebb377fad60df365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48bf95e7ef6c5f14db8a551b3ba22db93613f39ad04985f2edd3d34754daf89e"
  end

  def install
    ENV.append "CFLAGS", "-fomit-frame-pointer"
    objs = "tree.o list.o hash.o color.o file.o filter.o info.o unix.o xml.o json.o html.o strverscmp.o"

    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}",
                   "OBJS=#{objs}",
                   "install"
  end

  test do
    system "#{bin}/tree", prefix
  end
end
