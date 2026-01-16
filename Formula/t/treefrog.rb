class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "2c878603e8dd609ddabb02ee0e3a74fe306ccdf93ea65f9999f9a60ad68249be"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "472dc077d93e2bdd8944a167f143a692b09b9cad986863a2f807a7a5ca0f769b"
    sha256 arm64_sequoia: "3cd5de64e354398012b990b47e63657cdc50b676819214c2888b8b715b8679f7"
    sha256 arm64_sonoma:  "11189ca8d064f982fb2712cc29d5687c9235d3c92c1995bb6a8c7caf522c3425"
    sha256 sonoma:        "059630842f97bd3996453939787ea983fbe51618355cf049d7bcea551d4f9112"
    sha256 arm64_linux:   "cb74d250416af73e5314724745f813a40a6238c14642dab59d2cffa7b4b19276"
    sha256 x86_64_linux:  "891c89d4b27108e6fd7dc708bc6e4e10ee1ed2ca72af7311e38458884f7408ae"
  end

  depends_on "pkgconf" => :build
  depends_on "glog"
  depends_on "lz4"
  depends_on "mongo-c-driver"
  depends_on "qtbase"
  depends_on "qtdeclarative"

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

      system Formula["qtbase"].opt_bin/"qmake"
      assert_path_exists Pathname.pwd/"Makefile"
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
