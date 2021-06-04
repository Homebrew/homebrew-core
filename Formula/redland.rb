class Redland < Formula
  desc "RDF Library"
  homepage "http://librdf.org/"
  url "http://download.librdf.org/source/redland-1.0.17.tar.gz"
  sha256 "de1847f7b59021c16bdc72abb4d8e2d9187cd6124d69156f3326dd34ee043681"
  revision 1

  bottle do
    sha256 arm64_big_sur: "f54c731eecd682be899b7b8b5ab3424db134a1a48fe7076f0113deedb9a7f057"
    sha256 big_sur:       "60ddb8775dfdff43901aac1138929c688b07e744304e24e1cd3d6183000620bf"
    sha256 catalina:      "f30068d691ac2748619a288912235236e905f672b1f80a974e95425c5f102a10"
    sha256 mojave:        "711bdaeff62854f878f02e8fab9782337ee87ebf7398757d7780eb3c8971310b"
    sha256 high_sierra:   "407f9f1bd2a8682684660826fce445077c33fe3e7f1bfb05e7c0e265e2edacfe"
    sha256 sierra:        "0ed03c897836946cbadf2e390bd25c79eeb6ad34ea1144ef69d8bf1dfbfaf2eb"
    sha256 el_capitan:    "38eac3bae25aa65cbb7b688ecfaae91ab79c0c292e7505596ffc3b409bc8ca3b"
    sha256 yosemite:      "6047842b51137c968df4787bbfcf2080b4f32b73bb9d3412fa117ee9c1ff22d2"
  end

  depends_on "pkg-config" => :build
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "sqlite"
  depends_on "unixodbc"

  resource "bindings" do
    url "http://download.librdf.org/source/redland-bindings-1.0.17.1.tar.gz"
    sha256 "ff72b587ab55f09daf81799cb3f9d263708fad5df7a5458f0c28566a2563b7f5"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-bdb=no",
                          "--with-mysql=no",
                          "--with-sqlite=yes"
    system "make", "install"
  end
end
