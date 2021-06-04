class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.0.2/soci-4.0.2.zip"
  sha256 "3c8a456579320dc828cace5aa20d4d10690b273a50997e9c195d0b270fa668ba"
  license "BSL-1.0"

  bottle do
    sha256 arm64_big_sur: "6ab0518edb52f96d06c28fa20fe21eb29551bc933216f36588c87d8f535966fa"
    sha256 big_sur:       "34a4e4e20bdd5bb3c6d5c8a61badd4d7fc45f99acddb4f8c37ce29eb00dff378"
    sha256 catalina:      "eaf4f958498990043369a8af4395ff592c58717bc08b38f2905e3d4b4be6e94f"
    sha256 mojave:        "0cecd3377c20b8bfbd1129d2e10f2aaa8382586881716a7f3b3fb00fc041dc12"
  end

  depends_on "cmake" => :build
  depends_on "sqlite"

  def install
    args = std_cmake_args + %w[
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
