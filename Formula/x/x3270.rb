class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "https://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga10-src.tgz"
  sha256 "398c11a4bc862cb3f8536fe26a4c576d6f18756a446718af89b4fa5a972154c6"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "e0a50602a236f191cd93a8aadb1ecb1ffdfb8332c2fc46018c3c801b573483dd"
    sha256 arm64_sonoma:  "928d0a205bbf28583b87124807574012c0ddfbb55be731b105c7b34bd2179b3b"
    sha256 arm64_ventura: "5944432475eeacf621090f117dd36cd4fd829397a83b41dcb25581c7e90de386"
    sha256 sonoma:        "b14a00d5f2e2c7a596e6f17cabf29cf45d0f85c8d37745d7891f8776dac099fe"
    sha256 ventura:       "78c70e7aacfed1f6162ee4260ab1f210cdfa2e2383f596da7dd5960c5268b722"
    sha256 x86_64_linux:  "a09b51f8fcd15a28844963ffecda7b30a6a3dae2624dc3019e0dbea23fbcbf02"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "tcl-tk@8"
  end

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk@8"].opt_include}/tcl-tk" if OS.linux?

    args = %w[
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
