class XmlSecurityC < Formula
  desc "Implementation of primary security standards for XML"
  homepage "https://santuario.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=santuario/c-library/xml-security-c-2.0.4.tar.bz2"
  mirror "https://archive.apache.org/dist/santuario/c-library/xml-security-c-2.0.4.tar.bz2"
  sha256 "c83ed1b7c0189cce27a49caa81986938e76807bf35597e6056259af30726beca"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "191f8cd399323f5a0be7664ab9f058ef7a4b252129ed5d7bf4603f88ade0fa94"
    sha256 cellar: :any,                 arm64_sonoma:   "934a7e2e26afeaa06c455b763598c2ea69fcb7d9aa0fd7820e67d85c6f921551"
    sha256 cellar: :any,                 arm64_ventura:  "fdb50f5de05f8d23f82c401d5e2a7bd948d66805c443fffcc13db9abce41d558"
    sha256 cellar: :any,                 arm64_monterey: "56b183bc43fcb0b7b06c5a8ef52ee47134bdc46c254bcc5a28582d7c6036762e"
    sha256 cellar: :any,                 arm64_big_sur:  "4becfaae51067f844587b674f6bb46653f1923e723acc3f3ac8b6d1993d7d4a5"
    sha256 cellar: :any,                 sonoma:         "2d066f460fb76ec63824bf58641c8e1b85c2d47ccc1a7fbbf60fd333e381a74d"
    sha256 cellar: :any,                 ventura:        "bbf7e9efb91480a35ff315ba9dc7126ff77b6091b32d5037867a2e02984cf866"
    sha256 cellar: :any,                 monterey:       "91834747f036480abdf6df45bdbafd5eac50e4ad18c8abf4dfdfbd2f7d731f07"
    sha256 cellar: :any,                 big_sur:        "32d2ddd61821d3b0f9327f8a7c21154889b15ee74e599e6f9e88896ce9e2f14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "401bcb0a42250c10513897bb2b53412ec82d5f8cdebe16c3780d7c1f835f40d9"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xerces-c"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.cxx11

    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    assert_match "All tests passed", pipe_output("#{bin}/xsec-xtest 2>&1")
  end
end
