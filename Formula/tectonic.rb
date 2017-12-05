class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.7.tar.gz"
  sha256 "c39acc8a4e2e102245037fd2ea3e77b058d25e29bbab0dcc53a3167c5d3fee2a"
  revision 1

  bottle do
    sha256 "de996fc5c22cd897eb1cdd50878f40ee9a98e23bce307f1c5e25d5e664ea4345" => :high_sierra
    sha256 "787cbfd0e4b7b9f7c9373ba19a7bce68083103c70b6a7d87117afaa3d9d5cab1" => :sierra
    sha256 "b4203c4c3b2428ef5430670964817ea960c74495c5d6978bd0a57a10d83b3705" => :el_capitan
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
