class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "64df0107f60282b8f0c9522e5e09f7b579250db6020a963867868ce8ed96f19b"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:  "b58ca4317e30adedb59d41270a99d96c790e1cb1e5f40aa75e9805bff65eaf62"
    sha256 arm64_ventura: "20c25b9f4a108e4805a451b03cc260540fd025dce3a6941098b51d209336bf45"
    sha256 sonoma:        "088dbd82c52cb6fec05a1959fe3149663a9dcffd42d7d22670ca5d549a69e3e0"
    sha256 ventura:       "14453c03abbe561b759e9632d0945e3624e142045d46a66137e894eb774592b2"
    sha256 x86_64_linux:  "73c073c6e5cf1956fe2d69c56264b2e2372845bf09d789a460cecca3738580aa"
  end

  depends_on "pkgconf" => :build
  depends_on "glog"
  depends_on "lz4"
  depends_on "mongo-c-driver@1"
  depends_on "qt"

  def install
    rm_r("3rdparty")
    # Skip unneeded CMake check
    inreplace "configure", "if ! which cmake ", "if false "

    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared-glog",
                          "--enable-shared-lz4",
                          "--enable-shared-mongoc"
    system "make", "-C", "src", "install"
    system "make", "-C", "tools", "install"
  end

  test do
    ENV.delete "CPATH"
    system bin/"tspawn", "new", "hello"
    assert_path_exists testpath/"hello"
    cd "hello" do
      assert_path_exists Pathname.pwd/"hello.pro"

      system Formula["qt"].opt_bin/"qmake"
      assert_path_exists Pathname.pwd/"Makefile"
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
