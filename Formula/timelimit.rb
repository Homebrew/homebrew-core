class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "https://devel.ringlet.net/sysutils/timelimit/"
  url "https://devel.ringlet.net/files/sys/timelimit/timelimit-1.9.0.tar.gz"
  sha256 "34185bbfe807a912f352f4e2f634c9c3781810b376c4bba947a2381611e7d72c"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a4d896430260125864a8b8e22aabf172e36c8f8942faece7db8d502c568a690" => :catalina
    sha256 "4b868a4ee5bd9e424e6ea4aa36fc828d6efd3f07b1d72063bbdb5a0c59baa276" => :mojave
    sha256 "872dbbd21820c6d08513f29bc0c024f8584c7d7b7b6b4b436553414d08fd6950" => :high_sierra
    sha256 "5fdeeb6ef9c0306f7195187b8068bc4f84de79d6f6716977a262ce26abb3b1db" => :sierra
    sha256 "d36206d7c4ba1431fb592ad9335e9ae3bea8b983245cec1e65cc24318088bd86" => :el_capitan
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
