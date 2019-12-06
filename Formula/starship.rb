class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.28.0.tar.gz"
  sha256 "b3279f9b6abbd1ec98c8ef480ab1a11056f7f06a3f75deeb215c82185f4c33e2"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cbce976f93925fb9988c2fde7124ec513ceb6e6c3cf42b9c8980410e8088fdcf" => :catalina
    sha256 "bf2c3f7615968ba79fd1dcf836ec896be13207a482fbda397fab596ae1da9684" => :mojave
    sha256 "8cdd7d51cc3477f014dc053bb4db6c15bcf18719125e8a2eb99e308412274f69" => :high_sierra
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
