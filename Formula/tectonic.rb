class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.10.tar.gz"
  sha256 "4b7c65692e97704dd3ffee3f4b3aaa57f3e478a2a5c6689dc9347be23ab65897"

  bottle do
    sha256 "99ffb0b1c4c5c962b223980fe69c028407e07986108ec4eae84e3c68faee6de6" => :mojave
    sha256 "013cd38e6835aaf9565519bbee59c7eb13e4837e0fc3cb122589417bf42673f4" => :high_sierra
    sha256 "21abd1ad30c0e98ae61d323325312508e4a683ab82db0275f15ffe2235babfa5" => :sierra
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

    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
    pkgshare.install "tests"
  end

  test do
    system bin/"tectonic", "-o", testpath, pkgshare/"tests/xenia/paper.tex"
    assert_predicate testpath/"paper.pdf", :exist?, "Failed to create paper.pdf"
    assert_match "PDF document", shell_output("file paper.pdf")
  end
end
