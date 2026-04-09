class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.1.2/soci-4.1.2.zip"
  sha256 "ac51bf6accbfae17066c8f9535cdd7827589381117254bc9c92ea2483abfa153"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/soci[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_tahoe:   "d31676b530369e902ca7ef093254b8651d457d608d5fc3f043af44f399cfac1d"
    sha256 arm64_sequoia: "d743ca216502631c357219d8e9062147831f2f5de3d20e18e8707e0fda86b9fc"
    sha256 arm64_sonoma:  "b54a46e8519d45c7cdaf573d0744206603c4858aeaeeba7edfd982af15ae8eed"
    sha256 arm64_ventura: "2816ca114d5b253b1a2910275280335e342ceaa9b5fc37b029c7b3c794e7789a"
    sha256 sonoma:        "b470aff1683dacca56bd59826456c815feba82c68876f937dfe5a36b4c63a10e"
    sha256 ventura:       "bf622c8bb7659153f4414864eb3243274c6e96ee892132ad67e918c68a4eeb63"
    sha256 arm64_linux:   "7bdaa9f509b7eda5c845454d1a64cd0620f400fa0bceab65273433da986a6551"
    sha256 x86_64_linux:  "bd1e51bb043843736d53493af5b7c84f5937a9a2bcd79b19336a69aecddb3061"
  end

  depends_on "cmake" => :build
  depends_on "sqlite"

  def install
    args = %W[
      -DCMAKE_CXX_STANDARD=14
      -DSOCI_TESTS=OFF
      -DWITH_SQLITE3=ON
      -DWITH_BOOST=OFF
      -DWITH_MYSQL=OFF
      -DWITH_ODBC=OFF
      -DWITH_ORACLE=OFF
      -DWITH_POSTGRESQL=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~CPP
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
    CPP
    system ENV.cxx, "-o", "test", "test.cxx", "-std=c++14", "-L#{lib}", "-lsoci_core", "-lsoci_empty"
    system "./test"
  end
end
