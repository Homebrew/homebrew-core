class SpytrapAdb < Formula
  desc "Test a phone for stalkerware and suspicious configuration using usb debugging"
  homepage "https://github.com/spytrap-org/spytrap-adb"
  url "https://github.com/spytrap-org/spytrap-adb/releases/download/v0.3.5/spytrap-adb-0.3.5.tar.gz"
  sha256 "e33a342aa461b56a8d857c2c29b743658bd87b4ade7bed20399dea2cea01b0f8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8428084b606a2e3833254e703fbe4008de6dfaaf89ca1f8ff87e6fe2f70425cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4309532f2c887a32ef4a0f85176b3b767c4205a5b23b2df774f44372f41c8ced"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9405e4ed5fbe1ca731a3680a79c5ade64b34b1f7400564e547aa61b4865170d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43d5058fc2de380c055716f508f140ba0eff5a282841be511a538aabde113834"
    sha256 cellar: :any_skip_relocation, sonoma:        "135532f2cab5daf44e7317ef497934ed9bebfa524143bb9b7634af8be0a682f7"
    sha256 cellar: :any_skip_relocation, ventura:       "8720d4e3019e969e56bca91c765a19a89fc1f7ece8aee8afd951493fe62fd9a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8eb6db8813e8a10e0b5df9d66beab230cc98e19a3282969f3607f986bfbcf3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d2341a2950197714739dc5f7f7be663e31429d7fa187abe2086006171c96367"
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
