class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "2c878603e8dd609ddabb02ee0e3a74fe306ccdf93ea65f9999f9a60ad68249be"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "896f7bb5986da74d32a1ee21c1ce38f0f6dca1381114d3e07af0f5e5b8f5deae"
    sha256 arm64_sequoia: "46170c044203d63ff6d4db157b955104874b0cf9be190e32915bfccc752c31dc"
    sha256 arm64_sonoma:  "3ea9a8155b553bcb0a9593759ca408cc5d532429b0be7ae89881af2a75cb3314"
    sha256 sonoma:        "58ec3bfaebd43a660e01b08570090120fd6c9bd38aaeb4b30e8c268a59f408f9"
    sha256 arm64_linux:   "6acdabe0c364720beaee152b6de4b9c1a14bfb1f238d3d43e53c9be1e7a82b8c"
    sha256 x86_64_linux:  "76475986419e64d57fb94386bf3ac5e4adc577652413579d3fa770dbbfc03d89"
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
