class Sqlitecpp < Formula
  desc "Smart and easy to use C++ SQLite3 wrapper"
  homepage "https://srombauts.github.io/SQLiteCpp/"
  url "https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/3.3.3.tar.gz"
  sha256 "33bd4372d83bc43117928ee842be64d05e7807f511b5195f85d30015cad9cac6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38a875f10418420ffb6575efe36900bbb6b538b7cdc04d5b9627f3cee23f9a4a"
    sha256 cellar: :any, arm64_sequoia: "616fb66c49424941f10f030687dee31c3e8b695a9189ac305815fcaac6c0d4b3"
    sha256 cellar: :any, arm64_sonoma:  "076151d30d6963eddd94d888291aa48dcd85014fe88617589a14327a047b25d0"
    sha256 cellar: :any, arm64_ventura: "7057a2bc42ad8e9589b026321820b80b74484e81a132fc0a5735a3a859d2e279"
    sha256 cellar: :any, sonoma:        "5dd5d668c1c3db5110762193fffb6dfdce72347fc36a04f59ef69e7cd62307b7"
    sha256 cellar: :any, ventura:       "c61fef2285650f0f382d594e23fc5c325cdcc7a49cdcab6f562be643454f905b"
    sha256               arm64_linux:   "e317fdf972b53582cc2596eefe496652b1477cca94b16c83fa9baa51c5ae4bb6"
    sha256               x86_64_linux:  "9f74866fb8f4c43679d0bc7992e2f4276a10afcf294ae72a13f2f5d6d97e8db6"
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
