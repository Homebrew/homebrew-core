class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.3.2.tar.gz"
  sha256 "4d923d32af7db33f3c0a6655b258e857a2ca564912cf85ddce14e9b1b7d495bf"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "60cb58ec52cfe85e491151078212316420be58c7ace22bb63afc46594ed5d192"
    sha256 cellar: :any, arm64_ventura:  "3a1e70c83423d0d4ede8afaebd5f86304973060616bdb8e26d2573d8c1e5cc68"
    sha256 cellar: :any, arm64_monterey: "ba3dd413abe47ce61cee4d42cc2b7b097208499e033ade1d77f1c43ebc8c9d36"
    sha256 cellar: :any, sonoma:         "ecb704bea46a2a94309a8166005c54fd13bf25860ddb50f9b022cdb978c4956f"
    sha256 cellar: :any, ventura:        "fb88c5e25e7ea3362d4fa63d4779e4edbe2dd4b1974a4357092c78c6ee043bcb"
    sha256 cellar: :any, monterey:       "b73bf740eb26ea3fa177a9368974ddf58a197d9a6989dafba20e2485ccacff8f"
    sha256               x86_64_linux:   "5ec84154d0d544b011eb244e6f45a4bc74bf9f3e12eeb327287cfd91da1b140e"
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
