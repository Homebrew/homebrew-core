class Timelimit < Formula
  desc "Limit a process's absolute execution time"
  homepage "https://devel.ringlet.net/sysutils/timelimit/"
  url "https://devel.ringlet.net/files/sys/timelimit/timelimit-1.9.2.tar.gz"
  sha256 "320a72770288b2deeb9abbd343f9c27afcb6190bb128ad2a1e1ee2a03a796d45"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/latest release is .*?timelimit[._-]v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6de9b594eb3e3f9509fc78a4c7ed04a1f91bf7caef6fb175bcca2c3f4d0709f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "942effb229cb7f279a5cd4471bf3b70111bd0c79f286ad4954f924dc9805d096"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "857697f444d4ddc8658970890885230fe12eb21474cb212112a3ccbbbbaf81b3"
    sha256 cellar: :any_skip_relocation, ventura:        "423aa0f95a7a8aac71a1dc99378049a4f5a467426c59c24f9628c6dcfb3e705f"
    sha256 cellar: :any_skip_relocation, monterey:       "04d40a5e190cb1ed96e44690538d8445b7e097663a5df16577ad90e3ff3f7d01"
    sha256 cellar: :any_skip_relocation, big_sur:        "3888001f62e0dfdf0573b405dc2c0c5a36ce1274d1091a0cb0f38ee18438cfc4"
    sha256 cellar: :any_skip_relocation, catalina:       "e083932ebe7fa08f9afaa28254e5a73df07a29bf072cb932065678d708127a87"
    sha256 cellar: :any_skip_relocation, mojave:         "c0259eec4d6e78c2faf7c3860e5c47dffdef165dff28ef7992f7e9bf0914d0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a67387373b1409dd8e80893ccef41f0cf75d02c7256c35c19691bed52b5d8d"
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
    assert_match "timelimit: sending warning signal 15",
      shell_output("#{bin}/timelimit -p -t 1 sleep 5 2>&1", 143).chomp
  end
end
