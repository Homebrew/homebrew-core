class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.net/"
  url "https://github.com/libxmp/xmp-cli/releases/download/xmp-4.3.0/xmp-4.3.0.tar.gz"
  sha256 "8c2bfeba91282bd79fbb3c9b90f9b0f6a7dc61f84c9a4fb2e4a01776ce0f81e1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "4b0ed19e822b10ffb401686f212cd40e8317b2b2a8062131aea81af29e1ca840"
    sha256 arm64_sequoia: "827d5de28c8c9c3c2f8b91f7e107fa1ec24777e75e70b59ba0f6e22dd7fa6263"
    sha256 arm64_sonoma:  "f76343ee866498fd243770813aa6540ce0076462ef7ea031093890563fd0b6c6"
    sha256 sonoma:        "ba07f514ac50b72a5a0af249aa53610b6615778c7dad7edeedc06dd8acea4d6f"
    sha256 arm64_linux:   "7b8bb21bd902a1b7fb8288e7fbda094b365cd1146bb407a12b68b45e29ca8507"
    sha256 x86_64_linux:  "2c7e626e658c88f98a46aff117b9fec0b248493840375532d58fcf8660ce333b"
  end

  head do
    url "https://github.com/libxmp/xmp-cli.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libxmp"

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Fast Tracker II", shell_output("#{bin}/xmp --list-formats")
    assert_match "Extended Module Player #{version}", shell_output("#{bin}/xmp --version")
  end
end
