class Tnftp < Formula
  desc "NetBSD's FTP client"
  homepage "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20260211.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20260211.tar.gz"
  sha256 "101cda6927e5de4338ad9d4b264304d7d15d6a78b435968a7b95093e0a2efe03"
  license all_of: [
    "BSD-2-Clause",
    "BSD-3-Clause", # src/domacro.c
    "ISC", # libnetbsd/{strlcat.c,strlcpy.c} (Linux)
  ]

  livecheck do
    url :homepage
    regex(/href=.*?tnftp[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e6465644d4137221c858dda232f99f049e01a413a014426d9ca6c5c00a73134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa0e1a41b2b9a2005237d072de38763cc96372ff7321938c0399bb9e7288489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9dec17258f2179ede83e7ac1d6000c7c0798a6a590e1055b88a3eceec065315"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd334d6226939c4f040a017dbfb4b2ddc2aead1069a4f2a8ba58d81cac60f7e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0075ea6e8fb9822064a7ae05522c002c01036f0c45a94b9fc62f7c8f02bfd49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e91159c7e5d49cee3fe378c3c971cffe559d28528936751c6f07bb1ea970f5e6"
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
