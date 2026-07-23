class Rogcat < Formula
  desc "Adb logcat wrapper"
  homepage "https://github.com/flxo/rogcat"
  url "https://github.com/flxo/rogcat/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8b4d90dd1254ff82bc01cadcb8a157dc4d66d2e987471ae3c3eaa99f03e34ba3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd3b52bb78be0697f011c4b822049cbb3458c442bfaede275a8f2bf601edf35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03ed4acdf899875651f2b7a66e3ed51b0864cea322411ceb19288dec67b2226d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eed5b19de42f726126da7bc2cb2b7bc8b1850e0fbfcb9acbfa69335ebbf5926f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9740ffa33292f023d3f022ef9163fa2229edc22c70f2f15fa3895c88e3fbcd97"
    sha256 cellar: :any_skip_relocation, sonoma:        "e379f5d4de1e946270892f79a61530443c059f96e58aa4de9efbc012b909f511"
    sha256 cellar: :any_skip_relocation, ventura:       "d4f5fb5c2f78c91a879c848a8806662e58c791b5b71f1ced85bec4636e059ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "804c7881f8a8cde87ff51033907d9169c8c1b2769900ee1b7aa003dbcbfce62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bbec1da8e32cf17191a67928887276c14b89863ca3cfa8654741166a19ee5da"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rogcat", "completions")
  end

  def caveats
    <<~EOS
      At runtime, adb must be accessible from your PATH.

      You can install adb from Homebrew Cask:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    output = shell_output("#{bin}/rogcat devices 2>&1", 101)
    assert_match "Failed to find adb", output

    assert_match version.to_s, shell_output("#{bin}/rogcat --version")
  end
end
