class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/v2.1.0.tar.gz"
  sha256 "52ae63955230c73378701fa039da21c2879db5f9d7df20835ecb4c9b09ea95bb"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "1734d8c8739ea6565b7c55b0febf27d1ab3f2d596b79b24bdbfd242cd3b8a58a"
    sha256 big_sur:       "fd6ee4faac0658730d5619f0fef1f6951c0ad3e9cbd02533a047f0756f63ae17"
    sha256 catalina:      "b2ab9fe0c552a34c501c16e28863213ebaaad4dd1042b97252468d5831b2e084"
    sha256 mojave:        "99089c0b5349dc91cef9d9b4835cc3a648eec2fc423b6b876d31d73473b05903"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt"

  def install
    inreplace "src/corelib.pro", "/usr/local", HOMEBREW_PREFIX

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
      system Formula["qt"].opt_bin/"qmake"
      assert_predicate Pathname.pwd/"Makefile", :exist?
      system "make"
      system bin/"treefrog", "-v"
    end
  end
end
