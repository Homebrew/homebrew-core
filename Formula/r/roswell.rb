class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/refs/tags/v26.10.118.tar.gz"
  sha256 "19d61198ec747bd8ee0ab0764547d95e74907ef8f73cc4a4e72c9277d22b53e3"
  license "MIT"
  head "https://github.com/roswell/roswell.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "391182a12d785a131591facd11be19d09748529a32504020b5ae5736a6fbbeb6"
    sha256 arm64_tahoe:       "c4b7558af350bb23ddab57d2dc0e9a07735676ca3187a3ef113b7f2cb23516ed"
    sha256 arm64_sequoia:     "e6ea6621a13f77942343405f1efd68666dfe71de9e4e010f13b3fd463b84f990"
    sha256 arm64_linux:       "3b02aea3cb60aaecb3ecba07d8dc184c42304782bd3f198e29a005f2dfc5d0f2"
    sha256 x86_64_linux:      "42a9c0c5e9bd63538357117a8dd33d753319bcce12bd8734326b28559219f07d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "curl"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_path_exists testpath/"config"
  end
end
