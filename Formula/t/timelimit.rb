class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "https://devel.ringlet.net/sysutils/timelimit/"
  url "https://devel.ringlet.net/files/sys/timelimit/timelimit-1.9.5.tar.xz"
  sha256 "96b39c61a850d3395eaf4dde5fd22c290854d42ff69f192b12aef05d99d5ddbb"
  license "BSD-2-Clause"
  head "https://gitlab.com/timelimit/timelimit.git", branch: "master"

  livecheck do
    url "https://devel.ringlet.net/files/sys/timelimit/"
    regex(/href=.*?timelimit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d739825827aced3ed4918a118bd0c1ecfa12ed1b62cbad35ca5776dfa88dd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0b3cc2491751845884e3fd423dabbe384feaaade91c862296621b374d057e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee9bc7dd5a0d9ebdaa8b26cf20906f7f826d4570ccad0c6aa561722d2fd8c053"
    sha256 cellar: :any_skip_relocation, sonoma:        "480b41130ef1e98ac240611a793389c7b832b78bd557f0f2f7210335f94ac65c"
    sha256 cellar: :any,                 arm64_linux:   "3656d4e1aa38b7582e0665ef8c3ceb02958ff5dfcd0aeae2d948b0c919b843ac"
    sha256 cellar: :any,                 x86_64_linux:  "efb44a105ef0d77a5be31e5b4025de8c80b515b49ad31f07b05a24de6a7c0b5e"
  end

  def install
    # don't install for specific users
    inreplace "Makefile", "-o ${BINOWN} -g ${BINGRP}", ""
    inreplace "Makefile", "-o ${SHAREOWN} -g ${SHAREGRP}", ""

    args = %W[LOCALBASE=#{prefix} MANDIR=#{man}/man]

    system "make", "check", *args
    system "make", "install", *args
  end

  test do
    assert_match "timelimit: sending warning signal 15",
      shell_output("#{bin}/timelimit -p -t 1 sleep 5 2>&1", 143).chomp
  end
end
