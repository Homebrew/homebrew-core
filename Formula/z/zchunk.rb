class Zchunk < Formula
  desc "Compressed file format for efficient deltas"
  homepage "https://github.com/zchunk/zchunk"
  url "https://github.com/zchunk/zchunk/archive/refs/tags/1.5.4.tar.gz"
  sha256 "7e4515412a331b31ebfaef91978c01e937fc907149fd1ab21a4661f4e3799cee"
  license "BSD-2-Clause"
  head "https://github.com/zchunk/zchunk.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "001e71f0d8acc6bf0269090ff5c8cf767d5e882d6c14e816b0e0a3929e173690"
    sha256 cellar: :any, arm64_sequoia: "f6d47a3e639835edd983cbebd77e2699885224a1c71db966d0b3407040c04b2c"
    sha256 cellar: :any, arm64_sonoma:  "437e49c0af3f551c9b8a782c113837e8d90470785f0536d58c8fcd98e992345d"
    sha256 cellar: :any, sonoma:        "9dd5de16c658c7a29f33017286dc686d72b6e5ac3dd6446d4bc7abad05d9053a"
    sha256               arm64_linux:   "0e2d464108b65668267a5a9e7226a12823f1314c2cd2fc4e9a1b2177dfeceb91"
    sha256               x86_64_linux:  "815a1909e17eb500e49de8e89ffd0667c3464fd625b50ec71f92aa4db0704afc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "openssl@4"
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
