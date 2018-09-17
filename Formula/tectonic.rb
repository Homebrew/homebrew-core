class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.8.tar.gz"
  sha256 "e979988f89714e04e45caa894796ebce66e4ecba05bad8a9af0c323f574ed6af"
  revision 1

  bottle do
    sha256 "6fcddff4f23ae86a90e1c374b5c4f2aea0ff4684ef2d98dc4186b8ea24e4e8f2" => :mojave
    sha256 "3b3cd8477c1a706e05908a4a4131741fa69fd6e9a6f9acc4b91b66fff1d51e23" => :high_sierra
    sha256 "49b3824f125845d9ecb6f1d7ff35878af459efb135ca9b180fc672f00c0ec02d" => :sierra
    sha256 "57df3cd7e38a5e6d7777af8e3aa5b6da6515b00e8bd7c6ddbecc201b9c2e3ef6" => :el_capitan
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
