class Sqlitecpp < Formula
  desc "Smart and easy to use C++ SQLite3 wrapper"
  homepage "https://srombauts.github.io/SQLiteCpp/"
  url "https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/3.4.0.tar.gz"
  sha256 "9910ad8bc0a821856bd6d9fa7cb0b457883108f2b803700256b451077ed6dc05"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1456f9074e75199a86acfecb33829bd9d0ce27e006c3143f640ed58b3682c47b"
    sha256 cellar: :any, arm64_tahoe:       "38cdcc64ecff9acf74a9c205e3babd92d527f2f2bb81deab76eaf4d64ec271cd"
    sha256 cellar: :any, arm64_sequoia:     "c87126aa77e2c061907d3ad90b051af334eebfcc943ac121477b83f7dc66ba42"
    sha256 cellar: :any, arm64_linux:       "9806af528517e5a606cd1e1e5952d117cec16eb414cce0380062a053bb051e56"
    sha256 cellar: :any, x86_64_linux:      "275ba91fb7ba4908b4ef74b2aff627cda180ae5267380c2f617b047085eaf49b"
  end

  depends_on "cmake" => :build
  depends_on "sqlite" # needs sqlite3_load_extension

  deny_network_access!

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
