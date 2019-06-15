class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.2.1.tar.gz"
  sha256 "7b9956a2b9fa26536c6af0c3a1327721697e792b846658c69812d3072f82eee8"

  bottle do
    cellar :any_skip_relocation
    sha256 "69f1b64f8ac819cc253ed5f3e92fe9174e3ebaf3f350179517d0a9c88caeaa9b" => :mojave
    sha256 "15aa6ea4ce97d45790b5f2b0490533c9f1d24a55354673a32e3ca545db61d8db" => :high_sierra
    sha256 "c8c714d705315698f8d69df6a26c227e76d83956267e8eb95025b5fd21043d06" => :sierra
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
