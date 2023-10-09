class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.03/suite3270-4.3ga3-src.tgz"
  sha256 "44d73c2614e5aa022bf16a1c8cceda2326e4c96a892da42f256ee4e13bc3a85d"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "7300bea10a772411ba86e44a3e76cf6705762249faf64225cc9cbc8d3909d901"
    sha256 arm64_ventura:  "66c420133f3273c8808d468402963160b5322706115fb04cf01ab8574e71c8c0"
    sha256 arm64_monterey: "e0acb175bd3a3969ffb3f865e17d9d41edca7c6221e42a30bca00d5aa68b6400"
    sha256 arm64_big_sur:  "f2ff2e45eddeecaad0e03b1f2d601539fd02740cbdf3a1c5e6b3eddd6123a811"
    sha256 sonoma:         "d6d3eeafff6fc161a986bf380667499f96961ab6f3d8e3fc255eee72fe7667d6"
    sha256 ventura:        "d22c0fd8ecc142570494b50644bfc972ff6a43894dc01d22d237828589ae3478"
    sha256 monterey:       "94cec9d1948cb40b9d169cbc4267b7b4f27135dfac52a9b4820980f748745c6f"
    sha256 big_sur:        "4205866cc9cda834f11f0e7aa2018be598e72404b117356cc924b0144ea24b33"
    sha256 x86_64_linux:   "d743d4ac5943098c71ae80620159ecfce874088b4b323bd98832ccc8c52bf4a6"
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
