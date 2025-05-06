class Treefrog < Formula
  desc "High-speed C++ MVC Framework for Web Application"
  homepage "https://www.treefrogframework.org/"
  url "https://github.com/treefrogframework/treefrog-framework/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "67cbd3d2ee9810007feb97694c6eb1f7ddf9040210e69ca3adc7995c96f63df9"
  license "BSD-3-Clause"
  head "https://github.com/treefrogframework/treefrog-framework.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:  "e42ddfe0fa827d1f960ad9ebf94515bdd1e6515c84fa3a466e309118870da58d"
    sha256 arm64_ventura: "46ea6cafe756b381432a53c52cad8bd19f4066ad6ebb5af04ff6371cc0f7cfdf"
    sha256 sonoma:        "dd238ea3df08da065ff476dbe01bd9620dedc69da885c4554b7eda53b6a63ab1"
    sha256 ventura:       "4f29217b878dc7e40a20db0704a4273798dc429f72c86595baa882bd39eca03a"
    sha256 x86_64_linux:  "5d9f3deacba06b0fee54e42f69653d224caad91c4feb04100982237401f8f5fe"
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
