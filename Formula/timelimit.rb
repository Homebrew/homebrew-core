class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "https://devel.ringlet.net/sysutils/timelimit/"
  url "https://devel.ringlet.net/files/sys/timelimit/timelimit-1.9.2.tar.gz"
  sha256 "320a72770288b2deeb9abbd343f9c27afcb6190bb128ad2a1e1ee2a03a796d45"

  livecheck do
    url :homepage
    regex(/latest release is .*?timelimit[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f890d907623dd9b857710b9d7eb1d3256ba0ba7f620576a28313522343b648f"
    sha256 cellar: :any_skip_relocation, big_sur:       "6660e64fd509f5e3b58a1ce3b6e8dffbdc4cbb35eedefca5b133e5bd3009f378"
    sha256 cellar: :any_skip_relocation, catalina:      "5a4d896430260125864a8b8e22aabf172e36c8f8942faece7db8d502c568a690"
    sha256 cellar: :any_skip_relocation, mojave:        "4b868a4ee5bd9e424e6ea4aa36fc828d6efd3f07b1d72063bbdb5a0c59baa276"
    sha256 cellar: :any_skip_relocation, high_sierra:   "872dbbd21820c6d08513f29bc0c024f8584c7d7b7b6b4b436553414d08fd6950"
    sha256 cellar: :any_skip_relocation, sierra:        "5fdeeb6ef9c0306f7195187b8068bc4f84de79d6f6716977a262ce26abb3b1db"
    sha256 cellar: :any_skip_relocation, el_capitan:    "d36206d7c4ba1431fb592ad9335e9ae3bea8b983245cec1e65cc24318088bd86"
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
