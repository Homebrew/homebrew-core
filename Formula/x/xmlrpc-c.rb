class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.59.03/xmlrpc-c-1.59.03.tgz"
  sha256 "bdb71db42ab0be51591555885d11682b044c1034d4a3296401bf921ec0b233fe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1d369c20b8d76b185066406bfbaa099bf7462f26165e6734252414cc3a971f49"
    sha256 cellar: :any,                 arm64_ventura:  "c29bd340bc32364aa214081ca40fd6a042ececc311ce0edf0bcab8e502a835fb"
    sha256 cellar: :any,                 arm64_monterey: "b23dc45476a28a4de6c1f7285cde97673fb5c33a45a7f3a2e33c3e2d08f5375d"
    sha256 cellar: :any,                 sonoma:         "407c17da02e3da57459bc93996cb577f1924d89d270862123d4ff28d07bb8b2e"
    sha256 cellar: :any,                 ventura:        "48a4c8f0ef37a3cd32a6f3807b2cc822504f97183f690e274af51b7ce3b8bb18"
    sha256 cellar: :any,                 monterey:       "73bc4fafd8f55237e34deac603f21362426deffe736e4d024ba35c172de21811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a7ce382255b9fd59a88eb4af9c051b75f0ee1e2d9b93b279dfcbdf522838f1"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend",
                          "--prefix=#{prefix}"

    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/xmlrpc-c-config", "--features"
  end
end
