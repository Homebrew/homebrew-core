class SpytrapAdb < Formula
  desc "Test a phone for stalkerware and suspicious configuration using usb debugging"
  homepage "https://github.com/spytrap-org/spytrap-adb"
  url "https://github.com/spytrap-org/spytrap-adb/releases/download/v0.3.4/spytrap-adb-0.3.4.tar.gz"
  sha256 "8553beb5c403f3cbcf7b5e7ded052e4b31efe8e798ec81e2bcc16aba315f5429"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "767ab98c11d10e8e8511f5ae28fe2d4f8c0b22b33f25c2cedc7d4930f4a49fe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1da4d2335d1376e64a7c7ff85e35a720b024ba221e961143d413af1770d17901"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "608c7bfa4cfb114233756f3e22752012de20440a87497135e1a47fdfb7524205"
    sha256 cellar: :any_skip_relocation, sonoma:        "26072c153a6aa612ea399f0d047edf7221c7074e2bfb4d398f0b6311d01cd47f"
    sha256 cellar: :any_skip_relocation, ventura:       "e3e6bf1cb665f4ede66a844472452a8301daf939039a969deb3fad2c5d4feb4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec460a61e435a13444af946629525bf1df71431da02c37ee3b18dac5fd07ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669e16b037b182eab249fcd9f60678995c16ce97cabb25b8b8daf820eeb6c384"
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
