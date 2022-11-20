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
    rebuild 1
    sha256 arm64_ventura:  "7f8a656ccc4652e2f3bb6f0a4bd9efec456987d00aeaa248b12d61eca5bd6457"
    sha256 arm64_monterey: "50a95c4bfbbdb9b917d2fa7d48c4088d8562ab7bc0fee4577b77233beb5110ee"
    sha256 arm64_big_sur:  "6f9ab601a283b8d09ed126ea56c211a20c6402e3a1f435bb3414106404cdf206"
    sha256 ventura:        "c0216f4e6e281846c5364d137e4232d0aa6586c878995725bee5fa8d4b647830"
    sha256 monterey:       "1f978cde3384620e8949fe82bf351d0c9a41cbfd305d3fb4003045ef3319a4e4"
    sha256 big_sur:        "4cac5c40a0e13a60b65924c31fda01accdc64d4a941c70f216937abf7efd5e07"
    sha256 catalina:       "51beca49fe3504df480e5dda142d4feefbeb4007fcdf35158cafdd71820e29fb"
    sha256 x86_64_linux:   "c779dc8dde4b68594fc501e53a49f17b193a0c507335e608663479bde6022b35"
  end

  depends_on xcode: :build
  depends_on "mongo-c-driver"
  depends_on "qt"

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
