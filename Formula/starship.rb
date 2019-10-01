class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.19.0.tar.gz"
  sha256 "552836c455925be7443bbd43e77093785f0b7db7cc2cff0907e7746c3d56dab2"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9f6f0b79facc663d054481ea8f494185d35d8b9fc3770b30869055963b6ad2cd" => :catalina
    sha256 "9448248f3005457dd5e43f906962d05f24ee5106700b155b714598ed93a3f60c" => :mojave
    sha256 "a79ab34f1ea041b815d4467aea4cfda6bdf368895717bb93b8867cbd38464853" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
