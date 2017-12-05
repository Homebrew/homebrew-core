class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.7.tar.gz"
  sha256 "c39acc8a4e2e102245037fd2ea3e77b058d25e29bbab0dcc53a3167c5d3fee2a"
  revision 1

  bottle do
    sha256 "abd542b5d03c0fd9c71fdd8b36d6c93c58d5c65b3316b9fa0f829caf9b11eca4" => :high_sierra
    sha256 "b9d9a6442a534d421e459ebd38850475cf5ad5170d535226ae1c60d1821b434a" => :sierra
    sha256 "e19fd0b57de2b8226a2e269fdf31d19c30810727a5eddb17ced35e3ce7b4bbc4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl"

  def install
    ENV.cxx11
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version # needed for CLT-only builds
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].opt_include
    ENV["DEP_OPENSSL_INCLUDE"] = Formula["openssl"].opt_include
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl"].opt_lib

    system "cargo", "build", "--release"
    bin.install "target/release/tectonic"
    pkgshare.install "tests"
  end

  test do
    system bin/"tectonic", "-o", testpath, pkgshare/"tests/xenia/paper.tex"
    assert_predicate testpath/"paper.pdf", :exist?, "Failed to create paper.pdf"
    assert_match "PDF document", shell_output("file paper.pdf")
  end
end
