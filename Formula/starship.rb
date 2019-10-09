class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.22.0.tar.gz"
  sha256 "ed60db278a8d7cf45a21814ea80afe8b83fa5f6cd79a10844c7296d9670a48a6"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a4e1bdfe984359d6063063e1835a87c4eceac3bcb20633b850344c747418b83" => :catalina
    sha256 "0bdbe6fe74af42c7caa1b82de5794a5b7d4291100e5a1a994e155bc6beca4f92" => :mojave
    sha256 "de0752141e36a625b912fea558361c73c779b64218533527bc27058b2e456955" => :high_sierra
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
