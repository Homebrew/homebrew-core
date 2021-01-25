class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.0.1/soci-4.0.1.zip"
  sha256 "ec25f69df0237882bb9035c69e21d91e62f0c6a2cd6f9f0153bbf00b435ff6b2"
  license "BSL-1.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "1110442edee6672ede9b93dccef0a933508d6aa9936ad7d7c82b9429965092ff" => :big_sur
    sha256 "367f4d37091b11f2e63e220361f9344622a93f8c961122901889c5ef132fb0ec" => :catalina
    sha256 "c51aea80672de81e7663b36e6ff39ce9cc3025aa3c531539424dd089c1b347a8" => :mojave
    sha256 "6e6fced1aa11defaed5f6ea4461b5bbf763b8f55349035e587c80c4bbd68df27" => :high_sierra
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
