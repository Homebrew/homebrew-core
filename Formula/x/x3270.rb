class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga4-src.tgz"
  sha256 "3b7bf11de9a05a5f203cb845bd8e7fb805c2a06ca606ccf8cdee4ff5c80caa4b"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7c7ce1ffed7aab1b72625995a334936b00723a7d94b9705db52926f4e88e6939"
    sha256 arm64_ventura:  "d8bdd222813020ed20b94b5abfa1674b232cd2798a9f0e5d4f274feb14abf555"
    sha256 arm64_monterey: "164d04fcc511a019b28ae4f6617b48aa3121797edde011bf59e3d53a342dc5ec"
    sha256 sonoma:         "5ef2414d4f60fbaa533ab2d990e165768695d14e9ccd0aa91ed0e0a325c1429a"
    sha256 ventura:        "c5256d047475d1e3ccf01b5c595d6eae42645835d9f1e9374da2debc80f4e9e1"
    sha256 monterey:       "19ff33d5dd27262d3e0a11b93631c3929439a674b94b9f85948806e9e23e75d7"
    sha256 x86_64_linux:   "2009855feeb6031dcf04e3c9603fd623675924bc8705b3bacbeccf9c202f55b3"
  end

  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" unless OS.mac?

    args = %w[
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *std_configure_args, *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
