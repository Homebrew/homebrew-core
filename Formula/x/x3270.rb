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
    rebuild 1
    sha256 arm64_tahoe:   "40bacb8fca3aaec8c2c541906da72f5901e48fc9c32e08df7d9e8955ddba3177"
    sha256 arm64_sequoia: "619e4f821224699da21abbbf4ce8c5038bdb22bec06734be199045a4c5504a40"
    sha256 arm64_sonoma:  "a3fa3dfdcb1b8a3c10922c1f930b049d88b050330b982d96ada2e54bed2391c5"
    sha256 sonoma:        "38a014060680924480e757610fe29aeff72f5bd0fce56032c76d3044fe71b2fd"
    sha256 arm64_linux:   "5fa38afa032d8c01d4ba0340d6bd429636fa63d2266a7ce4ca2428e6dd1f0276"
    sha256 x86_64_linux:  "cfc79e9762353f5b22bbf0bf4a5066e3d4df54cb7e0bec61d31944bfcf426512"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "python" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "bdftopcf" => :build
    depends_on "mkfontscale" => :build
    depends_on "libx11"
    depends_on "libxaw"
    depends_on "libxmu"
    depends_on "libxt"
  end

  def install
    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
    ]
    args += if OS.mac?
      %w[--disable-x3270 --enable-tcl3270]
    else
      %w[--enable-x3270 --disable-tcl3270]
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
