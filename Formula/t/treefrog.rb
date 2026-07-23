class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "f56700ead61bc33d0ac34833577179d4e75736c0b14f8ab2c4baf3e7cc1fd101"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "df068256bf4dda278c44da69ad912b03851388da843ba0e82afe2f97fa768b0c"
    sha256 arm64_sequoia: "075bd834cfc339f8daaea00cb2f0fc3c9a9f66aec0ca5f9a2fae54e254680d9d"
    sha256 arm64_sonoma:  "adfe1ee5af8a804f1bc31f3b02f33a4e703e6699b99440bcf24447b7793b8513"
    sha256 sonoma:        "97a2dc68d30b8ca364061a19cb19f4d45bae1a805c17203a4150ce5a4db4ee96"
    sha256 arm64_linux:   "016dfff2d6278b600ec9a8ab2b835c980e982e369e9deb46f8a928bcc1754425"
    sha256 x86_64_linux:  "b35372fd47ce84e392824e2364eb417d7b1a09831739a40987cdef5f3df9c4b5"
  end

  depends_on "pkgconf" => :build
  depends_on "glog"
  depends_on "lz4"
  depends_on "mongo-c-driver"
  depends_on "qtbase"
  depends_on "qtdeclarative"

  on_linux do
    depends_on "liburing"
  end

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

      system formula_opt_bin("qtbase")/"qmake"
      assert_path_exists Pathname.pwd/"Makefile"
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
