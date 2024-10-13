class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "90cc96a883c09e42a73b6ca7a8ed262ba59c398966c32e984dd3f9d49feda2c2"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:  "a4653a846f4b9223f14887e6d9da5b3fd8e743fdfdef236d0f2e953c347a79ab"
    sha256 arm64_ventura: "a3218c634e1b76e16154d467f62ca72ac88ba882320463035943b247c49d3a7f"
    sha256 sonoma:        "6f58123d9af9dd89a79172b17defe9bd0c6a1c3ad32cd7101301f2a829dfff8f"
    sha256 ventura:       "636ca70974a80bed833eea7c9b91cd66a887e01f7feaf26b4762339e20035df9"
    sha256 x86_64_linux:  "0dadd26e6024a82c296e5faefa8576642ea0127aa69c22c868458ba55800eb3b"
  end

  depends_on "pkg-config" => :build
  depends_on "glog"
  depends_on "lz4"
  depends_on "mongo-c-driver"
  depends_on "qt"

  fails_with gcc: "5"

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
