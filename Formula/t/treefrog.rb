class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "4b6fd5ab77ef375b0e39329eb052da971e97d0c46e7043d3eaca76ae4884f286"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "04efdcd8ca8589c1ac601e2ece09d5c280eeadafe2c41112f6022065f1f6ce4f"
    sha256 arm64_sequoia: "80c20b2962f0ede687fb148b4aeda8ae4bab8d6eae56077b43fef5a2ce3841bb"
    sha256 arm64_sonoma:  "bde60d299c6692f46bb878489aa8f6ad49847cb6afa2a830591c67a6e9e577da"
    sha256 sonoma:        "bd3da0bd20900a621ee743fb2d57156eb7bb4fa0f40bfa9858a21ac21f82fb9a"
    sha256 arm64_linux:   "6b8c616d68b837de41beba329bb232b884658cc08a1b3e7c7f0e8459367915ee"
    sha256 x86_64_linux:  "e6e2685fcefce98c7d60a6607f11512ae8e93e636a5bd6edbc7e841538950229"
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
