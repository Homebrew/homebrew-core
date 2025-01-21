class SpytrapAdb < Formula
  desc "Test a phone for stalkerware and suspicious configuration using usb debugging"
  homepage "https://github.com/spytrap-org/spytrap-adb"
  url "https://github.com/spytrap-org/spytrap-adb/releases/download/v0.3.3/spytrap-adb-0.3.3.tar.gz"
  sha256 "440182e5387085b5ef3635b1d167bd4e3b238961398ef855cef6bfc84a51d41a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "915081387c21b2fb8d759c80bb81d56d60c90812d292f6b584adc4609e12f935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6273760a4ff7dd3521db402e8803f7f9c87204078b223a313f965d266fd6183c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8429d19cd730a2e9cca586a87deeed3acec92567fe76e7a930d7d71b6ab8c73"
    sha256 cellar: :any_skip_relocation, sonoma:        "775867e687d968b6e4479d56008fe9769f3ad1198e73a7b332da2500977d17ab"
    sha256 cellar: :any_skip_relocation, ventura:       "0a58a3338a6a43ad303db539b4817ac6fb11ae4147a90f1235f74dab07e3c7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11311754c13ea45906c6e97a8a120bd2dd45d2ee403ce3169f25ec0059d45768"
  end

  depends_on "rust" => :build

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
