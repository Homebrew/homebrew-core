class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "https://x3270.bgp.nu/"
  url "https://x3270.bgp.nu/download/04.04/suite3270-4.4ga5-src.tgz"
  sha256 "bbee5a36c68f7818c1efb12fadc9ad5c0b7936134343fd6454722697aa2e0b3b"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c504af06e325316bac590d6df56e857ae8139826af60cfb6cbd728d750d34faf"
    sha256 arm64_sonoma:  "eb789ba088bb2a94356bc26f411de2940c888b94c784cf91326a692b2b1efd15"
    sha256 arm64_ventura: "32a47d2031ce6608310198c61f7e5edaf9da6bfaa075470b29dda039c5193766"
    sha256 sonoma:        "0ab40fb951595af0d131cfff5d6d27e3ffcc8ddcff35c5b5955696b55f852b21"
    sha256 ventura:       "82edc406ca1dbfc9914a8a51bab21327ddc6da3e6db0716bc8ea592580ad848e"
    sha256 arm64_linux:   "74be989d42404f2e54d2e951c3215965f46a3eea2daa37110d7a866bb5a7b087"
    sha256 x86_64_linux:  "e75d93e507400c3c20d2d37e43d3938a4c52016f35782992bc3b9291c3eaf89c"
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
