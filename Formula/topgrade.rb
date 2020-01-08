class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.7.0.tar.gz"
  sha256 "3aab23ea372cd3dbbb68a45fef2232b39ab668aebda5e19dd0ed47e254913d63"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0d401bf32561d01c2ae6f69492e921cce73d037657fa2351899f7b62f6e1f3f" => :catalina
    sha256 "d8e7a0932184bbe08d8c97366de929d07a4ab6d7ef8f7f727e51d9d84357e2f5" => :mojave
    sha256 "e1073973dec10d21db253881738940765ce31e4899586edf2935ef698cde0e59" => :high_sierra
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
