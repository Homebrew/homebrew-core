class Sqlitecpp < Formula
  desc "Smart and easy to use C++ SQLite3 wrapper"
  homepage "https://srombauts.github.io/SQLiteCpp/"
  url "https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/3.3.2.tar.gz"
  sha256 "5aa8eda130d0689bd5ed9b2074714c2dbc610f710483c61ba6cf944cebfe03af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70f5947567993c6f843def81f53c30dd6c97938351f46b4c6945829121f2a000"
    sha256 cellar: :any,                 arm64_sonoma:  "e7629104d854a8022d3c63211d816df17fb8f304f2abe7aada7b9a32d5c5faae"
    sha256 cellar: :any,                 arm64_ventura: "4f8f06f0ba6e6b70b51d86efc287439368bf2d7b4a7ba237dd5f1a5ff1cc814d"
    sha256 cellar: :any,                 sonoma:        "27240818ce5455b810ab145dc21d99b7d0b5e0cf6f69d019dc6e9849df3271b0"
    sha256 cellar: :any,                 ventura:       "e62d913c9d07e34f2567329f3ced74edd8390cc10e55e27d905cdc3cf581f1f3"
    sha256                               arm64_linux:   "6475b9433747a98e6453958795885c04d614c4f863b4f873992f24ed2b05c58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45157c0c0356c374f4ea81150008d9070fe570abeed9c20e0742ebaea08c08a9"
  end

  depends_on "cmake" => :build
  depends_on "sqlite" # needs sqlite3_load_extension

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSQLITECPP_INTERNAL_SQLITE=OFF",
                    "-DSQLITECPP_RUN_CPPLINT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"example").install "examples/example2/src/main.cpp"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"example/main.cpp", "-o", "test", "-L#{lib}", "-lSQLiteCpp"
    system "./test"
  end
end
