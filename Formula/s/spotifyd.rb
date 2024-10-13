class Spotifyd < Formula
  desc "Spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"
  license "GPL-3.0-only"
  head "https://github.com/Spotifyd/spotifyd.git", branch: "master"

  stable do
    url "https://github.com/Spotifyd/spotifyd/archive/refs/tags/v0.3.5.tar.gz"
    sha256 "59103f7097aa4e2ed960f1cc307ac8f4bdb2f0067aad664af32344aa8a972df7"

    # rust 1.80 build patch, upstream pr ref, https://github.com/Spotifyd/spotifyd/pull/1297
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/7cb21d6370a1eae320f06a4f9150111db0bbf952/spotifyd/rust-1.80.patch"
      sha256 "0bfc8c4805cc99c249d1411aff29a0d9107c3ce69f1fabbdc3ab41701ca4f2f6"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "dd6598774377cc653a1e34568c6afff11509e3fac350dc0084532ad1eaad97ec"
    sha256 cellar: :any,                 arm64_sonoma:   "a2305bcd95c814f04cf6bef9d9c01a2cd1b6ab1c3f0c9e2dc1cb6ee85f468556"
    sha256 cellar: :any,                 arm64_ventura:  "3237a0154b6fddbf87eaea3b4460c8a992b72217899637d479a31f2bcd7ba53e"
    sha256 cellar: :any,                 arm64_monterey: "25689c32e31f1b2990ffb54fe34ba61856951b8c81d09bea1a4cc4d02d8c6fd9"
    sha256 cellar: :any,                 sonoma:         "7f9e21a27e9b6af17a131d62c23758ba6e7649c9a8ef38bd51b63d7e76dbcbff"
    sha256 cellar: :any,                 ventura:        "af948d2987f9c1f31f7217981ab42a62356b51c6793dc4091005795a917845fb"
    sha256 cellar: :any,                 monterey:       "00d7a5bfb6a4b4cb59e52b6d154e7268b576ed255df3ac199eceed6e7f84ff26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4baab23fe6181c526b89960d0fb9db63bafea067a4ac9c6f5ac6af658267eea9"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "dbus"
  depends_on "portaudio"

  def install
    ENV["COREAUDIO_SDK_PATH"] = MacOS.sdk_path_if_needed if OS.mac?

    system "cargo", "install", "--no-default-features",
                               "--features", "dbus_keyring,portaudio_backend",
                               *std_cargo_args
  end

  service do
    run [opt_bin/"spotifyd", "--no-daemon", "--backend", "portaudio"]
    keep_alive true
  end

  test do
    cmd = "#{bin}/spotifyd --username homebrew_fake_user_for_testing \
      --password homebrew --no-daemon --backend portaudio"
    assert_match "Bad credentials", shell_output(cmd)
  end
end
