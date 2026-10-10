class XmlrpcC < Formula
  desc "Lightweight RPC library (based on XML and HTTP)"
  homepage "https://xmlrpc-c.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/1.64.04/xmlrpc-c-1.64.04.tgz"
  sha256 "509c3a3bffb77c81e2c364175ac70b95b799e5b695cc37d4bf833ec28fdfe0b6"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "92ab61ef54709bb7299665b7eb25f117f46a863d7849c39cc60a737855196141"
    sha256 cellar: :any, arm64_tahoe:       "1d0974886e20a7c9e125e8b499a31ead0cb85f2927c7633e3ec0dbb26b8d578c"
    sha256 cellar: :any, arm64_sequoia:     "fb66cd0c369f0b0301a8144b39463bfe35415cd3320d9eb10d74046d0f91df11"
    sha256 cellar: :any, arm64_linux:       "f69fbc28018a29cce2a7a950ac6ddd826cef548580d6ed71ae382e94e907255a"
    sha256 cellar: :any, x86_64_linux:      "9c9f7ae751eed30030b3dbf084d391b524d73e294faa39a3b2700a15aa91a333"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.deparallelize
    # --enable-libxml2-backend to lose some weight and not statically link in expat
    system "./configure", "--enable-libxml2-backend", *std_configure_args
    # xmlrpc-config.h cannot be found if only calling make install
    system "make"
    system "make", "install"
  end

  test do
    system bin/"xmlrpc-c-config", "--features"
  end
end
