class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.1.1.tgz"
  sha256 "d3c3d55f403af7c76556546325aa1eca90b918cbaaf6d3ab60a49d8367ab90d5"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4da9aeec79125e9e027d16f25d0d703aabca05a9ac53c7dc76bf43cec24c609"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b9d20b3e55614447a4ab3bbad644d2989d9477f3a80ea759673d622b6fbe1ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b6062c487cede94dc2de7dba25312c99b8897f7e994f3f3acef325c5ba4ed72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0993a195d369cb485df2db718bc5fa099cecfe09182e6ae641eb76b8dfe1207f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7acc625da24c30b237cc55ee4f25b549f7c7819d1154779f2780b90f258b64b"
    sha256 cellar: :any_skip_relocation, ventura:        "feb011717a6075f9c7a203cd538015913b60311adb4ae81a07994ed50f0ef54e"
    sha256 cellar: :any_skip_relocation, monterey:       "2658b197c482c9f78aaf9e27534eb9467fd65894f9aea9c281844f7c1195bcea"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7988d91bcec536888729d60055cfe1176fcb85db3edf75d742192f61c809978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def7fe0895d7e8d0d9c5090effa68e1536a090a613932938ae38fde80e7b2354"
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
