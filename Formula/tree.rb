class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "http://mama.indstate.edu/users/ice/tree/"
  url "http://mama.indstate.edu/users/ice/tree/src/tree-2.0.4.tgz"
  sha256 "b0ea92197849579a3f09a50dbefc3d4708caf555d304a830e16e20b73b4ffa74"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://mama.indstate.edu/users/ice/tree/src/"
    regex(/href=.*?tree[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d6f837075c0dc311482fe60a0ecb479f891be53bc846c4ebc4b1094a849300b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "396aac226fd54af833a2cf5f3fc0985c5b63f234f9455ad481848764fbbf2e80"
    sha256 cellar: :any_skip_relocation, monterey:       "2514c051ffe6dda5dcdc30d5709e055d6b83c9892648cba17c5ff3f302c73dd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b913d303f43e57c65f661da1e7dd6c00d8e8c0886303c110ac15d4f0ae1e6a8b"
    sha256 cellar: :any_skip_relocation, catalina:       "e9ace54bd8824cf47f1c0108b7db70aee15436b3c93184ebfc498a3de0d387b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a35fc1014f454c3fcb15c176728068def9039f530cbc55d50110ed4e64c03a5d"
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
