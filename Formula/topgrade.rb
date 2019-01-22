class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.5.0.tar.gz"
  sha256 "413a25707600b7fd1dd9153850da2184c3a8e40841bdcb91533fe012313dbc99"

  bottle do
    cellar :any_skip_relocation
    sha256 "46a0142c7c50ca1a66278c2273b7146bf3256bf49c27f35ebad5cd82fe3494f1" => :mojave
    sha256 "15735e275ec3da0b6c7ecb637dbfc20623ec8b9e35999cf83ce86e72bb62f133" => :high_sierra
    sha256 "a971770d8af0c12ce5a53a34cb707520a9226af356ccfe17bf3854a5ccc2d3c3" => :sierra
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
