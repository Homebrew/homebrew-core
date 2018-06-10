class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.7.tar.gz"
  sha256 "c39acc8a4e2e102245037fd2ea3e77b058d25e29bbab0dcc53a3167c5d3fee2a"
  revision 3

  bottle do
    sha256 "53736e98adfaaae964b16d8e91af8328746af5232028b141d72c89fd8e62bf79" => :high_sierra
    sha256 "cdc46899eebc39130ba36e3ab07198c359e58d6b00622ac3ec5677747382d789" => :sierra
    sha256 "69adbf83a6d47ab1696abdb061fc859618d629a44cef32b50d81739824e8f00e" => :el_capitan
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

    system "cargo", "install", "--root", prefix
    pkgshare.install "tests"
  end

  test do
    system bin/"tectonic", "-o", testpath, pkgshare/"tests/xenia/paper.tex"
    assert_predicate testpath/"paper.pdf", :exist?, "Failed to create paper.pdf"
    assert_match "PDF document", shell_output("file paper.pdf")
  end
end
