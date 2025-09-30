class Tnftp < Formula
  desc "NetBSD's FTP client"
  homepage "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20230507.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20230507.tar.gz"
  sha256 "be0134394bd7d418a3b34892b0709eeb848557e86474e1786f0d1a887d3a6580"
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause", # src/domacro.c
    "ISC", # libnetbsd/{strlcat.c,strlcpy.c} (Linux)
  ]

  livecheck do
    url :homepage
    regex(/href=.*?tnftp[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2440ff711b034d1b7ebc3a676040bedba8424402704586cb3948c517541ab7f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29c3ac9c028f43ac6f65a2ff8c1d35499d90b6d2025a41853c699e9792195beb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f20f5343db721bf151d17ba4b37cf479e41fd8d286444bcaa7b6df312eb7b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "282fb33ade8765b9c59b745e26d314ead7a547f0d9362498d57e429a623cb8e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a23db7b60314ced9767889c224c4e0a743deda98e5861a62bcdf4a59dd87b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb344df376df4a00da292939661fa12e8dcdee1d5404906d7f533df3dc3dfb1"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "libedit"
  uses_from_macos "ncurses"

  conflicts_with "inetutils", because: "both install `ftp' binaries"

  def install
    # Remove bundled libedit. Still need Makefile.in to configure
    rm_r(Dir["libedit/*"] - ["libedit/Makefile.in"])

    system "./configure", "--without-local-libedit", *std_configure_args
    system "make", "install"

    # Add compatibility symlinks as we used to manually install as `ftp`
    bin.install_symlink "tnftp" => "ftp"
    man1.install_symlink "tnftp.1" => "ftp.1"
  end

  test do
    system bin/"tnftp", "ftp://ftp.netbsd.org/pub/NetBSD/README"
    assert_match "This directory contains files related to NetBSD", File.read("README")
  end
end
