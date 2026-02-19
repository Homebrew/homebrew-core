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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "152cbcfdc848a2a2b963b31b8dfb29c11c93178dbb234aa5e7d6469ec802e12e"
    sha256 arm64_sequoia: "ae84e96561ad0d9a0a773cf2c453f49e300f49b645f096100dcc422ae6b23628"
    sha256 arm64_sonoma:  "d284e7b1d3c842338b6a8e3e2ef148ddc380fbbb9012f43433d7fb4b7b5ed9a2"
    sha256 sonoma:        "44fb9a8b06c4b81a975091db3a26ca102674f05e1e8c832ae9466269ac66c988"
    sha256 arm64_linux:   "4ff7bdd89ef62a9863acd1657e7bec7876682719e38b6586b5433a01a1b39ba0"
    sha256 x86_64_linux:  "fd4cfbf6785e0639306e71e8caaa0c7b9c04f97d4aee32bd855ab06eca13aa7b"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
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
    system bin/"installmgr", "-s"
  end
end
