class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.4.0.tar.gz"
  sha256 "8dc0357f031e5ffb941f57750293540ec41ac1f0453774d3d2a031ef0e47a8e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc7a7b726a614262f11b2aa854db0847af1c4ad58e4042296fbc601d23643fbe" => :catalina
    sha256 "ff244409dceb0ff1639c652cd8b30c4d8528eba02a2330c5070579345dfa3752" => :mojave
    sha256 "df0083c23ffd2e78ce5c24b9515d8df5f4d3ceeb9fd058d5846abed9c8e99696" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/master/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/master/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
