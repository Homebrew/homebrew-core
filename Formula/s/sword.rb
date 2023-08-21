class Sword < Formula
  desc "Cross-platform tools to write Bible software"
  homepage "https://www.crosswire.org/sword/index.jsp"
  url "https://www.crosswire.org/ftpmirror/pub/sword/source/v1.9/sword-1.9.0.tar.gz"
  sha256 "42409cf3de2faf1108523e2c5ac0745d21f9ed2a5c78ed878ee9dcc303426b8a"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.crosswire.org/ftpmirror/pub/sword/source/"
    regex(%r{href=.*?sword[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "2439903e03cee94fe9b519c1597d9bebda08eebb38f353f775202b637748403a"
    sha256 arm64_monterey: "639a1f62fdf085c51a76a685ece4432a26dddc2fe7d4ba65fce337d6adbfc500"
    sha256 arm64_big_sur:  "aa8af3684bf4475f2c4f193ce2eee82751525f99dfc718b49495ba58f1866662"
    sha256 ventura:        "53e88cb788185e075f3d8bc1622098a2ca9f7dc506546ede4f3c29d5a3fd7105"
    sha256 monterey:       "47de7e7639fddd186eb0c2c806149ff7c2bbf90837d78bf3f912958f4a4afeb4"
    sha256 big_sur:        "85fd915531e0d5afa3ca380be523b09dd6c7ef4085ac4c7e26fc09e81c945228"
    sha256 catalina:       "65d2da4bfbc5517b4fba2d4da6a4b57ff2429126041c59ee83ad29886df71d70"
    sha256 mojave:         "84420513bcd1215cfcee1737022551b86d80059a0dfb1de6fc82dcec050280a2"
    sha256 high_sierra:    "42b2dfd8162cd7b96efeba4da340df7dafae5f581be6c6bbb47f37a07bd9f66a"
    sha256 x86_64_linux:   "d24c458654c45c7746615daf3627cd11c1a805ab2eac215f3d9c935575510a0b"
  end

  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-profile
      --disable-tests
      --with-curl
      --without-icu
      --without-clucene
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    # This will call sword's module manager to list remote sources.
    # It should just demonstrate that the lib was correctly installed
    # and can be used by frontends like installmgr.
    system "#{bin}/installmgr", "-s"
  end
end
