class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.59.03/xmlrpc-c-1.59.03.tgz"
  sha256 "bdb71db42ab0be51591555885d11682b044c1034d4a3296401bf921ec0b233fe"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c50dd6bf5c7a278e7b7046bb4fc4c714f376e1ece6d2a2f6b9dc567b2591cbcf"
    sha256 cellar: :any,                 arm64_sonoma:   "a37de64bbd2ff69db08d29c18be9061c383273fb7a2f4c437bcc97609b2d921d"
    sha256 cellar: :any,                 arm64_ventura:  "6acfdb7a4974c9dd956b9395b78f0acc1b669e877b23ad6e8acdf162477d86f7"
    sha256 cellar: :any,                 arm64_monterey: "f81cd7a5a3abc242fda56cf730a27007bec239731168e72cc89711e3f16e5a16"
    sha256 cellar: :any,                 sonoma:         "dac86be0a0f288eea63ecf9657bf6fdb89a1873dab3b415946b34d61b6640995"
    sha256 cellar: :any,                 ventura:        "7b6cc04921933e9e7a36eb8bc0ca36f7a1f67e2259385c462424a5f61fefe2ff"
    sha256 cellar: :any,                 monterey:       "2289714e60026a5ed0645aafed98f02dade60bb6884af5412362c5a3ef271779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdbcf2578d239e21752a3f06e0df6d0e27f26e83376536ecd16e62b9b8edfc5e"
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
    system bin/"xmlrpc-c-config", "--features"
  end
end
