class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "8c95e8a6c596b29ac192104eae00dd991e8c8fd66083fd2b34d6b223a5803a59"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03bf72371780986602090f39f79f00f1128b869208c1104ef48f33a3f2cead8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "017f6dceb462c623b3b9f8ba9b1a892d82309147399eb6ddfd6c5f08ad4c935a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ba11703b70f71d1fc1dc30c5ed3f3f522b9ec621c0f50a1ef0287da72d6650d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa69d2c0402500321035bb6d1f54205c5c64c2a40e8abb98e0f297e42cca2ad3"
    sha256 cellar: :any,                 arm64_linux:   "74c2fdb6e9bcb1e4c0642a87828d27b61aa9aece643fb99bdb9b2e6faaadcfe5"
    sha256 cellar: :any,                 x86_64_linux:  "92af67c387b7a2433fcbad26f9ca6ee7791bbdfe4e62c170f5ac0a143118da41"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
    depends_on "zlib-ng-compat"
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
