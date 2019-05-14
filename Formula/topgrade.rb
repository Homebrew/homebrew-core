class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.11.2.tar.gz"
  sha256 "f5895c087f8f5a8c0cce9f094ba4832715eac893e73af09cadfc4c64ad808185"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5f5eea6fdda89349d009650076d92c36fdce5184f073a26d0148d5c86b5fa67" => :mojave
    sha256 "fb8fb3b546fdd33a1bb8b42458bacc21b8b542abe7d09311893bc4f5b97afe8f" => :high_sierra
    sha256 "d9c3bedaa1eb18f05a0815584c109f32837c5dcbe4bbfd35e75324f437c751be" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
