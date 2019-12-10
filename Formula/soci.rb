class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.0.0/soci-4.0.0.zip"
  sha256 "c7fffa74867182d9559e20c6e8d291936c3bd8cfa8c7d0c13bb2eeb09e0f318b"

  bottle do
    sha256 "0fd00b5a595f94e6e62cb7f6976816bca6a747ed3a98b0327f5961548e2606ef" => :catalina
    sha256 "e0898c45669d19255465f990c9ac4ea6f6b42c4c6de7688d5ca137f77080bc55" => :mojave
    sha256 "bf08b482820dd4ce1613b662d573caeeb0e9e78d379d7f21dee9118833867e65" => :high_sierra
    sha256 "db0a84d0ac41fb65d0bdea2eccc652754bdacca85b8659aec879d85101f2d276" => :sierra
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
