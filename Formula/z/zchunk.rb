class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.4.0.tar.gz"
  sha256 "6def0481935006052774e034a22c18a1b668b8c93510188673138312003890eb"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4b8d09fb872cdd7e740982a9e1e765c70b993e586512018a585211946d3a7a24"
    sha256 cellar: :any, arm64_ventura:  "d6866cd3eb34f506fe9c359103a20df2c3222670f13826b1683d65dc0122044b"
    sha256 cellar: :any, arm64_monterey: "090d2064ae2e53c60451a67b4668382c6bdb3fa3a8c057e6ce5435771e90b4b4"
    sha256 cellar: :any, sonoma:         "5d8ea3878c25c1adaf8313fbc165a2b0899be58e9e987139cf549c10c2535a21"
    sha256 cellar: :any, ventura:        "2ed8820304fd30bdd834731914903e03cfc7faf8628bc01043b1a4056efd76e9"
    sha256 cellar: :any, monterey:       "31ef62e3d9c9320b3c86674266408d8f54a68f2ff619cf0ca63425a445a3029c"
    sha256               x86_64_linux:   "85b5b0ba7e45d7adb12c8adac25ac50eb3091dfc59a44d9c782c188ca46def38"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
