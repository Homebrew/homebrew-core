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
    sha256 arm64_tahoe:   "6c590ab7633fc8dd71ee9d3a932853153b237d933dcbc13795d17ea0f72d9ea8"
    sha256 arm64_sequoia: "8e140e267d0786df8221a31a14f56fdac6728c1bc5f1e6fc0ae95aae1e22b6ff"
    sha256 arm64_sonoma:  "ff256cb1df69bfd2e56379e162a100a23d175effbacafeafc932044dd614fe04"
    sha256 sonoma:        "0914d59133798fbdf1f742ce5dbcdf2643e1d0e9bf9c0ddcb59f08dbf44f4b4a"
    sha256 x86_64_linux:  "91ad5a3bd9ce905fc9abf6425e99544a1330cb248fbad24e5135b4a05d69aca5"
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

    # Fix to error: call to deleted constructor of 'formatter<QByteArray, char>'
    # Force to use fallback implementation
    if DevelopmentTools.clang_build_version >= 1700
      inreplace ["src/tglobal.h", "src/tsystemglobal.h"],
                "#ifdef TF_HAVE_STD_FORMAT",
                "#ifndef TF_HAVE_STD_FORMAT"
    end

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
