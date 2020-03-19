class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.38.0.tar.gz"
  sha256 "ad2ea8a4c02edcabd29b2b14ca0af2d42a38141eeb6ef05d72e9d541d6671d15"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e395c0227a781bb04554de649931efdb50952d52f0431f18ac4f02ae5d5188c" => :catalina
    sha256 "d50d05341d3ecf3329f59e1e92aeb8f4c3b519df89c0d775e667995c82f38d7f" => :mojave
    sha256 "8837011c07c7d9a96ca5ed9ba72eb500f96893d82b8893324b469ba22a12f015" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
