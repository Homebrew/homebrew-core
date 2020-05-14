class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.41.1.tar.gz"
  sha256 "80d1e0f27d33abddc9d1638b3abaae02196b9d8fbad8d8462082abc8bb909973"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a94177ea27e842888066bd0cb9e38d0053fc6611449751627f9f8356ff92edfe" => :catalina
    sha256 "38c7147237a43f5d8b331b354a8cceea27b1bfb4e1e80da2f83fb720c3000327" => :mojave
    sha256 "c0c99306e85a9ae9ca13a94a33e61fc1241d7d458df8213e9489ed14e25796c8" => :high_sierra
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
