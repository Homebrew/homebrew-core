class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga8-src.tgz"
  sha256 "81c0ba4447d97a7b483c40e11b39d4498bbc9af55fa4f78ccff064b3e378dc59"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9d32736f3bdd823db80c661a206a750f01ab3864afd236af897c1bb8ed2827ba"
    sha256 arm64_ventura:  "90ba3edfdacc0628dfae58cbc6b8b9465e368da2fedeeec9f7c272f5b0a021f1"
    sha256 arm64_monterey: "dc15bbd305d5c36a7bfe6e248ddb0a72119f3fa573e926b0735b2eee106b4be7"
    sha256 sonoma:         "c00e0a7a2e5e6c0f895c001fab50fa267a4aa5163ecb5a0dfa4c0a006bf28318"
    sha256 ventura:        "ecfacceb1bac8501db2c5ab6ea57f7fcc8c0ad254fd3b5cab5ddba6439ba1720"
    sha256 monterey:       "7758d551b51039a33919103a55e8f80313771e13af9b6fe5aafa5061e3228973"
    sha256 x86_64_linux:   "2d2986eaf9848a76bdd79934346b1f03194d271ebf2e4ba4633295182d4f8955"
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
