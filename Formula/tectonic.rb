class Tectonic < Formula
  desc "Modernized, complete, self-contained TeX/LaTeX engine"
  homepage "https://tectonic-typesetting.github.io/"
  url "https://github.com/tectonic-typesetting/tectonic/archive/v0.1.6.tar.gz"
  sha256 "5c201c979069dfb780040b42d8c516847668bd6d429eabb20f5fb15a3873832c"
  revision 1

  bottle do
    sha256 "6097b9140e73f5cd1f584991302fe10816980a9566ab19288dee511ac2c1e2f2" => :sierra
    sha256 "647a3ae4f31aaf517149c10fb1a805f6d1eaa83cd3d008e5d85fd1f57a987cdb" => :el_capitan
    sha256 "064efc61497c63d50105d58bf2e79d079a6833892f4b5d2134a17eaf21b8097c" => :yosemite
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
