class Toilet < Formula
  desc "Color-based alternative to figlet (uses libcaca)"
  homepage "http://caca.zoy.org/wiki/toilet"
  url "http://caca.zoy.org/raw-attachment/wiki/toilet/toilet-0.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/t/toilet/toilet_0.3.orig.tar.gz"
  sha256 "89d4b530c394313cc3f3a4e07a7394fa82a6091f44df44dfcd0ebcb3300a81de"
  license "WTFPL"

  livecheck do
    url "http://caca.zoy.org/raw-attachment/wiki/toilet/"
    regex(/href=.*?toilet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "bd5b942e1d680bf03e3cd4ca644c4468e4184804f9e42044cd4e8a3d8be4df13"
    sha256 arm64_sequoia:  "2c559d7c5172c0f9751ecb6a75a550e1202cf3f09a0cf867799672beea54c2b5"
    sha256 arm64_sonoma:   "e357c586a77052ed8e040b211e693d1f420c2667caffe012d5e5d121659bc3e7"
    sha256 arm64_ventura:  "24f5a74c74de3d9dd4a7ee917c9e2faa072c1062189b6272d8bb041a91f8be6a"
    sha256 arm64_monterey: "76a5e77f5e0c747a41dc7f087a65b4eb9817ab59e0b81b33fc4a98cc7c44cbfe"
    sha256 arm64_big_sur:  "962eed08eba86fe1f35bdc00f6cf7d119639b93a305451f0283517c5b89df15a"
    sha256 sonoma:         "66eb8162654bad10f2f6fe8bcee529b61c07e08d97fb4159dd13c903511f3da2"
    sha256 ventura:        "2f95a953e9876a0768f11f7017f045d3cf5edd2e79a42bcb997de08f6c478875"
    sha256 monterey:       "d5698e72ecfe4ed624397f0da8b342b8080b716d8abd6657a19d517463ffa399"
    sha256 big_sur:        "6656e1a05049339433307a78ae8df879f45903c179642361e0ef24331e3e44c4"
    sha256 catalina:       "816162aa8f967f14e6db8f9b48024ef5119c04955575299e02fe88b2b0158ac6"
    sha256 arm64_linux:    "b9b9b289bfeca15d75013d0cb29999beccaf644a914c8a6ce154be438a24c417"
    sha256 x86_64_linux:   "774d107ea52b43b2224252e84eaf529d8b944fa34746935d34a9c4bb791a110e"
  end

  head do
    url "https://github.com/cacalabs/toilet.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libcaca"

  def install
    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"toilet", "--version"
  end
end
