class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.4.0.tar.gz"
  sha256 "d7fc8459013097c0798f2b57ac1ff684077c8417c48fb536913edd94dda31738"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "8712234dd9f9658c56354abfc1938ad472b6f8380876e0eec3aadbdfeddd9367"
    sha256 arm64_big_sur:  "6a5556cf97c1d63684db9ea24c9aaa1dc22d7de4cb29e49252aee3d2bff81649"
    sha256 monterey:       "c0be4dc67572d563f76a1887a3e3cd44ae07da1c3231538cbe0606283c908fee"
    sha256 big_sur:        "5013810aa9eee1fc1bdbb0db23192ebfaa503d0ac8a13368e7d287827b35ab50"
    sha256 catalina:       "3c7bd7108e070f1abc86404197d4e40e7c8280e50c711d2efd300d7b855e554f"
    sha256 x86_64_linux:   "ae87c48444739c06ca1063e70bbc9f2863ed786e57493a0cbb89dff44a98853c"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # src/corelib.pro hardcodes different paths for mongo-c-driver headers on macOS and Linux.
    if OS.mac?
      inreplace "src/corelib.pro", "/usr/local", HOMEBREW_PREFIX
    else
      inreplace "src/corelib.pro", "/usr/include", HOMEBREW_PREFIX/"include"
    end

    system "./configure", "--prefix=#{prefix}", "--enable-shared-mongoc"

    cd "src" do
      system "make"
      system "make", "install"
    end

    cd "tools" do
      system "make"
      system "make", "install"
    end
  end

  test do
    ENV.delete "CPATH"
    system bin/"tspawn", "new", "hello"
    assert_predicate testpath/"hello", :exist?
    cd "hello" do
      assert_predicate Pathname.pwd/"hello.pro", :exist?
      # FIXME: `qmake` has a broken mkspecs file on Linux.
      # Remove when the following PR is merged:
      # https://github.com/Homebrew/homebrew-core/pull/107400
      return if OS.linux?

      system Formula["qt"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
