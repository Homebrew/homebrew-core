class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/brlink/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.0.orig.tar.gz"
  sha256 "5a5404114b43a2d4ca1f8960228b1db32c41fb55de1996f62bc1b36001f3fab4"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd7c803d65c1220c5f683324a6ec01c65b58262bd5c8e0edadbd5fca8247bb31"
    sha256                               arm64_big_sur:  "693fdd1c5fca04420ddc514398668a446fdc70a0d9ba9b3c1ee4a6fba0d9cb9e"
    sha256 cellar: :any,                 monterey:       "1e9d326fc8472fce03ffa4b8121ee57a042e33e1dc5a9928c35c2af8d66cfb06"
    sha256 cellar: :any,                 big_sur:        "0a1ef02efd94289dea92547ed6735422eaf66fd92a02d69472af8ae69bfdc056"
    sha256 cellar: :any,                 catalina:       "92ecf42593483a44d3a39af6e7e3be0a4336f499ce19dcdbaac7294ef7f7b4b5"
    sha256 cellar: :any,                 mojave:         "5478d8a1d013eaf8ce47c4c5b2e0afab9b2dbd76b4f4d3dbe09e6f0efa0683b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "748c1afa5578eb56c95c19ccb7c7f850eb44596f69d21ebb8fe25060f1f1224f"
  end

  depends_on "berkeley-db@4"
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "xz"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "No support for GNU C nested functions"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gpgme=#{Formula["gpgme"].opt_lib}",
                          "--with-libarchive=#{Formula["libarchive"].opt_lib}",
                          "--with-libbz2=yes",
                          "--with-liblzma=#{Formula["xz"].opt_lib}"
    system "make", "install"
  end

  test do
    (testpath/"conf"/"distributions").write <<~EOF
      Codename: test_codename
      Architectures: source
      Components: main
    EOF
    system bin/"reprepro", "-b", testpath, "list", "test_codename"
  end
end
