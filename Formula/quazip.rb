class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v1.2.tar.gz"
  sha256 "2dfb911d6b27545de0b98798d967c40430312377e6ade57096d6ec80c720cb61"
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
  depends_on "qt@5"

  def install
    system "cmake", ".", "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}", *std_cmake_args
    system "make"
    system "make", "install"

    cd include do
      include.install_symlink "QuaZip-Qt#{Formula["qt@5"].version.major}-#{version}/quazip" => "quazip"
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
      LIBS        += -lquazip#{version.major}-qt#{Formula["qt@5"].version.major}
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt@5"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
