class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.3.tar.gz"
  sha256 "c1239559cd6860cab80a0fd81f4204e606f9324f702dab6166b0960676ee1754"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b53bf839a2479d91bd033530ea182453a15a8376a92663b8b1c292e360ee81d6"
    sha256 cellar: :any,                 arm64_big_sur:  "0fa2cc876d433725d8db9ea3ba88281b073205ad178fc775b3b35d6a97cae736"
    sha256 cellar: :any,                 monterey:       "0527912fbff9a2699c9580afd57944a90b68043e0b675c9331ca9610a6d8d65a"
    sha256 cellar: :any,                 big_sur:        "16dfeecdd918f9d3b3149b75e6a9fa6a035e123b561d07dadc6da536fb775566"
    sha256 cellar: :any,                 catalina:       "5597a6c0cf6f0c002bd6b89f4f3880d360b70d10514233ff99c642435df11025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8a371641c6977250974eed98c54fe85267f37af8433e177bde4bab1fcd9908"
  end

  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on "qt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    system "cmake", ".", "-DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}", *std_cmake_args
    system "make"
    system "make", "install"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qt"].version.major}-#{version}/quazip" => "quazip"
    end
  end

  test do
    ENV.delete "CPATH"
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip#{version.major}-qt#{Formula["qt"].version.major}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
