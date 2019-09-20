class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.18.0.tar.gz"
  sha256 "6792e7359577eca6f858559ebbee80dee4ccb97039973f8ba6f14a05c6e38c13"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52bd1b0c7d40a58aa044dee78a2a51bd0be34d2409a3d7709282e016ac0a43a6" => :mojave
    sha256 "ad89799509e1975f9fd300b3287700b7ecbbd5418cf6a3734e81f504b1f30cea" => :high_sierra
    sha256 "80c3e7474a784edf761afbf2125a6aa6bf4a12d0e3d7917fd8ecb0e05c82a80a" => :sierra
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
