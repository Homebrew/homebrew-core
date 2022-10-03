class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga6-src.tgz"
  sha256 "093089bd672cd7424652cebdd4b77105c0ca686b12b376d5810d1ba07ca411c0"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e3977b6ea2a5db8988c1d78cba44a02a1e705db27cadaa58404e323a02803985"
    sha256 arm64_big_sur:  "b15fbaa76fea0ff3f5be128fb9c5cfe4223744e10012f461ceb184d9e6ad2104"
    sha256 monterey:       "4f66fdf0642cb1b4427bacc890c55851e24e09bf7c73478011586f5dc5b32407"
    sha256 big_sur:        "0bd89ade1161e3e3680f64bd256e61f37d261cbfc0abd8327d13c4fee94b33fd"
    sha256 catalina:       "01cc5f9b06fab6ec4e24854684bec3313586a0ff8c6417717fc1e12b7b196a5e"
    sha256 x86_64_linux:   "50ae82d5efd4877fb79359580443538d07f8b1b5a7c76cabda82ef2d5a000804"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
