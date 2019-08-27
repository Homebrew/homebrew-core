class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.13.1.tar.gz"
  sha256 "990b0e418224900824179bc6c8fca89566696be79d68b8af191da107b7414f46"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "815e807ab25abfa9836106d7718a5c6ba85ea7490b617da90d8474de365ba488" => :mojave
    sha256 "3ba47f8e0848a64a22265bf1586b604ef0f7becef941a5160f797c9c2ca834ad" => :high_sierra
    sha256 "3506ef2def0ea2d1e7edb35325cc874c42b15c760691171489f68a6fd64347a4" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
