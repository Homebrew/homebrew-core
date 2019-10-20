class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.25.1.tar.gz"
  sha256 "eb560643045c7e273525db414f2936289cf9bebdc6db0615018db77d8e6e10d0"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a693da74b8298152e897a4e7a0ff3395eb8e93d19e6a077115c181e72efa921" => :catalina
    sha256 "0f4c318949402f581b4f3be3f2f489aed60e79d3fbc8e9957da99eeddb680cf7" => :mojave
    sha256 "90776f7919b772b36608865559c4097d3c2bde7cde684b93e3df7165a8690b38" => :high_sierra
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
