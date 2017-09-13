class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "https://devel.ringlet.net/sysutils/timelimit/"
  url "https://devel.ringlet.net/files/sys/timelimit/timelimit-1.8.1.tar.gz"
  sha256 "7043d9ff1ec9650f7f50118529a4cea129720ea9d1035d986cb77e6358c7179d"

  bottle do
    cellar :any_skip_relocation
    sha256 "5085abbf18bc1e2f4aa65651feeebb7e5704de5e2712d82a32c854ba7438273e" => :sierra
    sha256 "dbd4adf91b29d800a9d84be457279ab0465185c951491015c50e0e6a086ca908" => :el_capitan
    sha256 "6ae0fbb95e2011aa3511ab5bc95a476f1de4216d972e93f312e8bebf8abbef3f" => :yosemite
  end

  def install
    # don't install for specific users
    inreplace "Makefile", "-o ${BINOWN} -g ${BINGRP}", ""
    inreplace "Makefile", "-o ${SHAREOWN} -g ${SHAREGRP}", ""

    args = %W[LOCALBASE=#{prefix} MANDIR=#{man}/man]

    check_args = args + ["check"]
    install_args = args + ["install"]

    system "make", *check_args
    system "make", *install_args
  end

  test do
    assert_equal "timelimit: sending warning signal 15",
      shell_output("#{bin}/timelimit -p -t 1 sleep 5 2>&1", 143).chomp
  end
end
