class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.16.0.tar.gz"
  sha256 "133888e190ce1563927e16ee693da3026d2e668d975ac373f853e030743775c5"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a4007d531448fabfc3a001c3e6d766e23be6110de120f6717c984b861ce3ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776271b363c182dfb5226aa7c60e1714c8b43f5826acf63610730bc178da3147"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a58e85e1e647cec4290336f29db4b2ba1e1f8814128ab5eed05ecff4cffa3bf"
    sha256 cellar: :any_skip_relocation, ventura:        "1a2a777bc300111d5f4cdc09caf8cc8ce74ab7172938eabce4d1e464a83b85c4"
    sha256 cellar: :any_skip_relocation, monterey:       "0ba30b7f99837320458a9332a7ae09b7755f830523f0289d61dc7c89639e248a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3de83ca0922d0157232366e9bf95e24c7b1b887429e2f724f4a87171f6e83d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63e19895e8afc93b2da3fd6d25e00c271ef072ecd73967ca680976405530ce1"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
