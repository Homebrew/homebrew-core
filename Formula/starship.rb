class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.26.2.tar.gz"
  sha256 "bc57c0083bb02a7d6b4fb6c7a9b7f6d1ecb315f7294aeb71834e2d4660a2fa46"
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
