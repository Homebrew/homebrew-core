class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "ab580fe31ca097306963d3189dae0b471f674377421d75f8aff6780d17b0414e"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:  "f3df866109eec865647812d2d3578fceb588f2d103a0472d893de834f44d0bdf"
    sha256 arm64_ventura: "6937cab6ad7b96a6cd30cc8e021d088bb704127eaeb7cefae560f47f5aa56b57"
    sha256 sonoma:        "c1c95ef9795cde56632a5f9c2c5aa702f1e2ef4f392845cc1b655d0bb2067e56"
    sha256 ventura:       "ef97dc3d4f74e9683449379b9d9087a55bae272348b1a63deeedcedd4997f0b0"
    sha256 x86_64_linux:  "216205bbe3f88da678d5fdb93161b71adc63d4ce94244525116ede90560549fc"
  end

  depends_on "pkgconf" => :build
  depends_on "glog"
  depends_on "lz4"
  depends_on "mongo-c-driver"
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
    assert_predicate testpath/"hello", :exist?
    cd "hello" do
      assert_predicate Pathname.pwd/"hello.pro", :exist?

      system Formula["qt"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
