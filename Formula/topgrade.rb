class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.6.1.tar.gz"
  sha256 "37313ca7a99f2cac84aaee8f95ebcc96b39be247b4dd982ef2380d3a25b62b42"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf9bcc304ad23ec7c180571947ccb0c787cdbae24a55ccc6517d62dcc6f4a53f" => :mojave
    sha256 "ce6d4bf4e9c6f43619e73e42989baa493902e0fcb3401055a8fa64f35abf24e2" => :high_sierra
    sha256 "105cf7c072c4e610525a006880d687f349d09bffd0e5c19fa7aaa638e48f86b5" => :sierra
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
