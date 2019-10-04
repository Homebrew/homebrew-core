class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.20.1.tar.gz"
  sha256 "8c87921ece4b6048fa18ecf95e7887b6266473ab74a9527512dd32628d7951af"
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
