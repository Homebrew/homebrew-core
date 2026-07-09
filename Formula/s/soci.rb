class Soci < Formula
  desc "Database access library for C++"
  homepage "https://soci.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/soci/soci/soci-4.1.4/soci-4.1.4.zip"
  sha256 "2fa7f41391101cd8d8ebdf870188030934fa6122f47063dc03c195d8135a746f"
  license "BSL-1.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/soci[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_tahoe:   "7b15200b32688aea452fd6808e3302f76ada2145ff7bc86f15f473ce58b5b6d1"
    sha256 arm64_sequoia: "83e193d6a298caf352f0fed677a1f6cf39e3aa7960388bec1c9a10d2c15b7347"
    sha256 arm64_sonoma:  "1ed9ad9e65400ef19501d345a69a7701df40093e12c54cd1e44b9af2febff587"
    sha256 sonoma:        "ad52bcaeed7c55109ca42125ff8f998add6a8a23d6e89907bec3251dc43289a7"
    sha256 arm64_linux:   "6c178205c0d2ab24ec398838b377348eac6b03a36e8fb970e4f847063d4b5a11"
    sha256 x86_64_linux:  "8a768b3f34b125668ac0d2329f1ad2eba14dce75c076bf3db1120918ad2bf24e"
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
