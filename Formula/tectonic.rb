class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.7.tar.gz"
  sha256 "c39acc8a4e2e102245037fd2ea3e77b058d25e29bbab0dcc53a3167c5d3fee2a"
  revision 2

  bottle do
    sha256 "fe69edcce8d1bee8aba0180d4ab4434073c4519b7a5677ba996246b24e8ff0ec" => :high_sierra
    sha256 "9b0aa550333d388f6d7794a0cbad1e3ea077d1de501739ae9c69849cc239e81e" => :sierra
    sha256 "34ce8a3d71046e782d43b247fb92a5407348f82959e7f13343365b3f0bab24f3" => :el_capitan
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
