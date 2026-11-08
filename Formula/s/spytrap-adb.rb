class SpytrapAdb < Formula
  desc "Test a phone for stalkerware and suspicious configuration using usb debugging"
  homepage "https://github.com/spytrap-org/spytrap-adb"
  url "https://github.com/spytrap-org/spytrap-adb/releases/download/v0.3.6/spytrap-adb-0.3.6.tar.gz"
  sha256 "8a6e9d43d1495fc052e4724500b43ff19e8bdaa097dde3a716413fe0bb9100fa"
  license "GPL-3.0-or-later"
  head "https://github.com/spytrap-org/spytrap-adb.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9970883677097abb76a26ca42b3e06f71a686239a42a983cb876ca9137f21a3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5bb3d333766ead455c117b439428997e1d8eed5dc9e2ccc7081ae2cb5c1c2524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "475f9bf6c484f44912e55aa27fbf4539601ed52f5550661974848171612c5dbb"
    sha256 cellar: :any,                 arm64_linux:       "adaef40a1f62dea12c0e07b0a8e919af5306e5cf511a041f9befb2290e5c5c96"
    sha256 cellar: :any,                 x86_64_linux:      "41f1d35118158c47ef71083b3d73486829026ce29a8d35de4afa9e18a8df28e3"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"spytrap-adb", "completions")
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    system bin/"spytrap-adb", "download-ioc"
  end
end
