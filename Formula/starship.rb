class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.33.1.tar.gz"
  sha256 "90e1f2e795cd0e694d7a514faeee19f881c35ec46811298adde692d606837d5d"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "97ea8e21a8cc2807a836f3919e1f5cda31569eb356aa92f09cc681afe039212f" => :catalina
    sha256 "f1194a352e64a374c82c1e82bad5740edda6b2fed5850ea4b29dbbaa7b1807b5" => :mojave
    sha256 "a40401ca62d92574a3e31ada071443f3f1baf2365aeab7c65d46bdc2c81f27cc" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
