class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.15.tar.gz"
  sha256 "846b3d5eef57702e8d18967070b538030252116af1500f4baa78ad068c5fdd64"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "432a4566b511529e97cfdb3ce395e8e2c07e96c893fa270a9e455485e4561bf9"
    sha256 cellar: :any,                 arm64_monterey: "687f4ba6cdad9ba9c4a690158d532b5f6fb7b0b09c3902ef1abe25bcc8363416"
    sha256 cellar: :any,                 arm64_big_sur:  "72e2019aaa7418023be2b17b3bdbfdcaf1fd3866526916f10963bc61f7b4b8cc"
    sha256 cellar: :any,                 ventura:        "77c9010033914895789fa3d941ef588b8d8d8484189d84710640982a0ce211ac"
    sha256 cellar: :any,                 monterey:       "95d5e50f6e32da6c7aa4da21c1a485d5fd8ceae9a42c6c4c2c6df551a1dada1a"
    sha256 cellar: :any,                 big_sur:        "4d6a220779a2ae2e74083453ddbe6033ffaaae74602eb7671081f34810c0d43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f688c6391245a0628cda90274daaa1cbc28fe5b4af7e9c6b8d9adec169a5b11"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
