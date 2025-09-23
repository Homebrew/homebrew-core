class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "https://x3270.bgp.nu/"
  url "https://x3270.bgp.nu/download/04.04/suite3270-4.4ga6-src.tgz"
  sha256 "8438eee59795cd3bfbf1963053369b9aa30af6b85e4d927b7254d24e992433b1"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c6607f88ba719c972e9727b57b4b9765cda8a3cf82f0ee3589fbdc5d1f27ebf9"
    sha256 arm64_sequoia: "41caa1c7a64de9870b59c7e4b834841ef3d65a211781a87d97edba44e8a1cd47"
    sha256 arm64_sonoma:  "c90a271931ac61368c956348a59b652bc4f984940d6841f5bbf59e75a8f52f57"
    sha256 arm64_ventura: "f6ca96db4ce44adea40987d324ef4f06b4e397675412bdd8826b2b7eca40d724"
    sha256 sonoma:        "c210a811cce3df9b27bae0f8053651004c72591af1fb56b045939330c461a134"
    sha256 ventura:       "bc355d6abd6ebaf5b7010ad6cbdbc65307e64398b0fa1282c48dd33230fce56f"
    sha256 arm64_linux:   "84d0e04798231f71fcc7c9a41811a56d2384ee1057946d4ef36a33483ee95d9a"
    sha256 x86_64_linux:  "2e4b13cca8d704575596f0a9f0161cda483e1af7f60ac18e3576d59b8673cff6"
  end

  depends_on "openssl@3"
  depends_on "readline"
  depends_on "tcl-tk@8"

  uses_from_macos "python" => :build
  uses_from_macos "ncurses"

  def install
    # Fix to read SOURCE_DATE_EPOCH as an unix timestamp not a date string
    inreplace "Common/mkversion.py", "strptime(os.environ['SOURCE_DATE_EPOCH'], '%a %b %d %H:%M:%S %Z %Y')",
                                     "fromtimestamp(int(os.environ['SOURCE_DATE_EPOCH']))"

    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk@8"].opt_include}/tcl-tk"

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
