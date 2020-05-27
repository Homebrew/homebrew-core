class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.41.3.tar.gz"
  sha256 "ce2c86e3f3a7d8cd2e1a204e7ef491473fdd93c41bb43a4718fdd66039f7bc99"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49bf8bbd460536e5f7683cb6db865ecf40bca4d030a8c41d60ae9c43cc2d7f5f" => :catalina
    sha256 "2c7da646a724e2e5cc2e40673e6f0502c604a531afd9e29799e09689a7a95ab6" => :mojave
    sha256 "3c94fc2e09b131b5ddf94fbf84efe5a6e9a2f6d925b0c9192331c3bf906ec840" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
