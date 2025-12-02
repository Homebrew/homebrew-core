class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.5.3.tar.gz"
  sha256 "832381dafe192109742c141ab90a6bc0a9d7e9926a4bafbdf98f596680da2a95"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "46b7edb3748b367ba4b35700dbd3369744c16b37d31e2843492ca47af28333c1"
    sha256 cellar: :any, arm64_sequoia: "46a25eac9dab8ba67c4c5180d5016806825d7adb3a1ace059616ff27a1a6ad47"
    sha256 cellar: :any, arm64_sonoma:  "bc949e0284c77f8794636418979ebc1b45f26a3559bd41b9c566ec79b294733a"
    sha256 cellar: :any, sonoma:        "39d1b2d55f294285fcdf94c11ead1d87e11ffbc80c541c059867c4d7bbcfe557"
    sha256               arm64_linux:   "1f97cc161198905c6092068d829cdf206aae5b92609adf419b63cb6bb38edaf1"
    sha256               x86_64_linux:  "45fae766d814be7734fd3815c7ed8e817feb045f901c270a243cb3d19e7f2e29"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "curl"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"zck", test_fixtures("test.png")
    system bin/"unzck", testpath/"test.png.zck"
    assert_equal test_fixtures("test.png").read, (testpath/"test.png").read
  end
end
