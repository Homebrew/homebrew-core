class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.0.0/soci-4.0.0.zip"
  sha256 "c7fffa74867182d9559e20c6e8d291936c3bd8cfa8c7d0c13bb2eeb09e0f318b"

  bottle do
    sha256 "b25ecdd8f098dc48dc20195cd8852533e47e12fe6cbac8bccb31db99854d9c5b" => :catalina
    sha256 "0dc4c5223dcefeefbdbc647dc7827adf7fc01fe52a23f3bd325d6cf32624e532" => :mojave
    sha256 "76d7380ed18a0cac1d883d6d38aea9f7a43b587584f4dceab1c32f56596341cf" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "sqlite"

  def install
    args = std_cmake_args + %w[
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
