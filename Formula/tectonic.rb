class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.6.tar.gz"
  sha256 "5c201c979069dfb780040b42d8c516847668bd6d429eabb20f5fb15a3873832c"

  bottle do
    sha256 "bfb4b5cc790c8aa94be88b05776ca8944725d0bb0efaffb6b908ac2a57c546bf" => :sierra
    sha256 "911f1157cd3a5a858f4338f0145be38da0025dfb4a008d138f9307498356decb" => :el_capitan
    sha256 "e53f3203f455be568b7d8cdb51b2008d87d2b5c8bcee55c4784157288242b479" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "graphite2"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "openssl"
  depends_on "zlib" if MacOS.version <= :el_capitan

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
