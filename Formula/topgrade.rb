class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.0.2.tar.gz"
  sha256 "83c9396f57da870240ae36108bcf25c838fffccf10636e5fb6cad88978bdb648"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca082a8725bd3b0e67a0c1f6fc217e5f1fc112fc6a87127942a99b900aba9169" => :catalina
    sha256 "809b9f531f667e3b111d406254a66882023d47d8868b64a2e5215aa0d215ee80" => :mojave
    sha256 "7697e12ac06247913735bfaae5e61f63121f548a6a8f066bb4509879f740e896" => :high_sierra
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
