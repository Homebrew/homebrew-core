class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "https://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/4.5ga5/suite3270-4.5ga5-src.tgz"
  sha256 "01576fa58598ccdd3d366febfaef61e3d1de93eb60a93f9ac6ba5faf84144c6f"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5eaa66210bd1a24f0aaa2636301f0a6886a31b96a244708861383d00b4ec0d48"
    sha256 arm64_sequoia: "f4fd0e4943283791da2f444454fc598a3ad8a185142d1d97659ccef54f16f6b7"
    sha256 arm64_sonoma:  "5b2dd7e19c4e313d15979367de0bc23267192dec8109dc4f42b9851e4ef6f5d9"
    sha256 sonoma:        "a8484001d4dc7017037da1946adfe25d79a59aa62e955d268f8142baa65a0453"
    sha256 arm64_linux:   "7e3bb3c8cdf506cc4256a6b32526c2bf8757dab5bdfbc4e2b2409d36bb1a3644"
    sha256 x86_64_linux:  "b339cd5bc13a6ae5c4f5567e700d1b1fa8b65f52c2218170553b6983cc523ad2"
  end

  depends_on "openssl@3"
  depends_on "readline"
  depends_on "tcl-tk@8"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk@8"].opt_include}/tcl-tk"

    args = %w[
      --disable-x3270
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
