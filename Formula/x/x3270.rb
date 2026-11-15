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
    rebuild 1
    sha256 arm64_golden_gate: "ea3453124778264fd8410b6a3be158e557daadab66c4197680851fc893623780"
    sha256 arm64_tahoe:       "449e02fc6cddf44e3790bc046985804b71c3fadb2e4fe0f7afa142eee75b8a1d"
    sha256 arm64_sequoia:     "e6d75144a80b4730a875a0960609af6961426646f92e21f8278eabf1252014bb"
    sha256 arm64_linux:       "26e35b6219fb72f3eed9c1c8444a3b84eab7fb2816dbf4f545671ffbf40cbc65"
    sha256 x86_64_linux:      "c6a8b41cba0c85ae6b5df9430d8515eb9f374e11b93d2a0e3f9519eaa0e0e141"
  end

  depends_on "openssl@4"
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

  deny_network_access!

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
