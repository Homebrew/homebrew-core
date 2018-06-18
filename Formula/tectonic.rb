class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.8.tar.gz"
  sha256 "e979988f89714e04e45caa894796ebce66e4ecba05bad8a9af0c323f574ed6af"

  bottle do
    sha256 "f5d4fe9a2041a90987912e79ad4b9b5c7c4a611dd17497dbff29e66c44b287b6" => :high_sierra
    sha256 "00737c34d87b0263dd6d2dc99ac45f26f4c6c73c0e54a41fdb0fc3a7a4ab8b77" => :sierra
    sha256 "e47a92175826f4d9fd37fc94e840945cec76c1cc866aec681921da89cba44807" => :el_capitan
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
