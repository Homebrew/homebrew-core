class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "https://oldmanprogrammer.net/source.php?dir=projects/tree"
  url "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.1.3.tar.gz"
  sha256 "3ffe2c8bb21194b088ad1e723f0cf340dd434453c5ff9af6a38e0d47e0c2723b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4f39e10fb168ba78da684d3341b9de003cc75de0fe69654816d24eda6d7d834f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0ff7ec061de0b347ca0c735aa199f30c57439134cc6ea1d8e66243986656924"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c2977827a57759b2661878fe661284c4c72ddc0c6a7f8d49e2814392b4f976"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ef85c4b4b00b63b41159241eefb3f0712326b03f4a3a0f92468fdf339916c98"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe9c14383700f0f5d8a170be81d9f344006e3a33ca5d14e7a9c6349e414ebac4"
    sha256 cellar: :any_skip_relocation, ventura:        "3a7806b8309c92599eaeb275b11d872048dd19d572f461c1fe28005873fb9389"
    sha256 cellar: :any_skip_relocation, monterey:       "3b617ca01cbcfff57c659b7678eeafd02893f8d82945325f3d21fb645db3ed3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d57629617283034eb02db149a2f441dab0872fe4b96547999ff0e7376f0c99a"
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
    system bin/"tree", prefix
  end
end
