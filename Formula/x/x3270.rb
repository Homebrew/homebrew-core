class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "https://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/4.5ga6/suite3270-4.5ga6-src.tgz"
  sha256 "06faf5ce883852258cc6a2a4da9fe5ce023e97d01e50625ff36f4a01ea703468"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d98a21ae48675fa3bf1901e468c2a09245206a000ec31b8b58ea56b3d9bd6ab8"
    sha256 arm64_sequoia: "58e3b3d5401b4db0e63539d122eda5de386bed1b6973ef88dc04789599b4b118"
    sha256 arm64_sonoma:  "9c27bf91ab48b87570a8a437cec920939c714563fd66d5d5ebe01791d069c8d2"
    sha256 sonoma:        "f0473cfa720f226dcf71ff593ad988ee127627afff065fa3a612d138553d6727"
    sha256 arm64_linux:   "85c3f9d9454286b88aee99f3fd8edc351d5b0a8920072abc855894c42a16dd02"
    sha256 x86_64_linux:  "4914534421e8d1394c8a6feb0a2f5dbf0b6c98f9e9807b59990e103e9ab326db"
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
