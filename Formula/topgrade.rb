class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.2.1.tar.gz"
  sha256 "7b9956a2b9fa26536c6af0c3a1327721697e792b846658c69812d3072f82eee8"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c8520fc3e38af6877d0490e6d2e83a6b00a93fca4929bcf81a1ff4d825b7966" => :mojave
    sha256 "4abaf445c56e4f40cd8ffd2980d4e28b21d056d1a9c69ec8b583d8ebcc10cf0f" => :high_sierra
    sha256 "77f820b54c71b5ff0d153f6e6da339ec6ca24fae1740690e651e81f02bc4301c" => :sierra
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
