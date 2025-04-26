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
    sha256 arm64_sequoia: "27aad9bf9750bcc9f3e22ca5150559af09105b01a684b2d7f91eba7757942485"
    sha256 arm64_sonoma:  "0f1fffff06aa9b8c0ead0cc40a740e7b68e3e3cf75d75b88bce4c5dcde44aa25"
    sha256 arm64_ventura: "cde560236680e967de2c50994f50ff6191b7e050f8743cd527a6f813d5047314"
    sha256 sonoma:        "a681f80c3fc9d2fef71fbbad22372459c35c42f1e1903158bd3ed86568774f84"
    sha256 ventura:       "947c464bdb65d405a4a6394d257bc7443bdd741e0a0650c824e7a26ca0f76118"
    sha256 arm64_linux:   "11ae872d7b58bf4a98111deb5eb80174998e0e20a9707aca53ab9e91e98762e8"
    sha256 x86_64_linux:  "052c65259275d5f9e458f3b0d15182e820d0b204872d32eee8d6c898c0988050"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "python" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "tcl-tk@8"
  end

  def install
    # Fix to read SOURCE_DATE_EPOCH as an unix timestamp not a date string
    inreplace "Common/mkversion.py", "strptime(os.environ['SOURCE_DATE_EPOCH'], '%a %b %d %H:%M:%S %Z %Y')",
                                     "fromtimestamp(int(os.environ['SOURCE_DATE_EPOCH']))"

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
