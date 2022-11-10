class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.0.3/soci-4.0.3.zip"
  sha256 "598abf573252caf71790af5ff15beca20af548440b610e70468edfd3c12d47b0"
  license "BSL-1.0"

  bottle do
    sha256 arm64_ventura:  "389f70f8884a86e67b2d9dde6d50796765d9360c2c3b31cc259ce32b8a87cd4e"
    sha256 arm64_monterey: "3071048f1067589c98521c479ad6ceeb317b70231072b227d67a7fc41bd81f27"
    sha256 arm64_big_sur:  "652d8306f60195b5689d236e5f4b876e0595480c97657c20f6ade9a49919f48b"
    sha256 monterey:       "09ea83bf0e12deff7e63da0f41f1c16573f6eb017336c907648bec515430e0f1"
    sha256 big_sur:        "6e2001b1bf50eb5c6d913f61abcfb9074ac4a8dba810cc7f80546ca1157b5311"
    sha256 catalina:       "0ce9776bb40a4b6d3dc6d1ea62885a952e32c868fff1305b8e7f33a1e09689f2"
    sha256 x86_64_linux:   "9a6461d6ec0bc9a1306f59a8a80c5c750f46b6bf13691f0e89b94c69399c0853"
  end

  depends_on "cmake" => :build
  depends_on "sqlite"

  def install
    args = std_cmake_args + %w[
      -DCMAKE_CXX_STANDARD=11
      -DSOCI_TESTS:BOOL=OFF
      -DWITH_SQLITE3:BOOL=ON
      -DWITH_BOOST:BOOL=OFF
      -DWITH_MYSQL:BOOL=OFF
      -DWITH_ODBC:BOOL=OFF
      -DWITH_ORACLE:BOOL=OFF
      -DWITH_POSTGRESQL:BOOL=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<~EOS
      #include "soci/soci.h"
      #include "soci/empty/soci-empty.h"
      #include <string>

      using namespace soci;
      std::string connectString = "";
      backend_factory const &backEnd = *soci::factory_empty();

      int main(int argc, char* argv[])
      {
        soci::session sql(backEnd, connectString);
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cxx", "-std=c++11", "-L#{lib}", "-lsoci_core", "-lsoci_empty"
    system "./test"
  end
end
