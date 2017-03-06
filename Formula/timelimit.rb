class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "https://devel.ringlet.net/sysutils/timelimit/"
  url "https://devel.ringlet.net/files/sys/timelimit/timelimit-1.8.1.tar.gz"
  sha256 "7043d9ff1ec9650f7f50118529a4cea129720ea9d1035d986cb77e6358c7179d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9363f55156c70c4e8727131ff7cb12191034b76cc3c5e65d70028a8b66fc871" => :sierra
    sha256 "90494e903f7305d6e1c5392ba75a1c41685d37287dfe92a446eded91f039262f" => :el_capitan
    sha256 "68028554a85b4b6f30bcfb3fbe0328ecf367c49fdbe8342e16e26fdb07f23465" => :yosemite
    sha256 "274c9d6ccab028ef9f8177537fd880f733e21676321b8c8d7e95306f3b454a22" => :mavericks
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
