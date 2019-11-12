class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.26.3.tar.gz"
  sha256 "33245c927bcbb1625ad747cf9d5e3e027eec6109f59522e2f02a65e55d513232"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "019f4188a7333079222d4badf7eca7e072261cfe315dd86d9a19cc307bf3484e" => :catalina
    sha256 "1733139a61d2f7b0ff92d9493103d3bd45fad72e847d4c9f233bd3c522ac2f4a" => :mojave
    sha256 "2af180a8e59d6c8676edd41fa4cf10ee38e0c7d5a1e096d7df8f3c853ba3cf5e" => :high_sierra
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
