class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.1.0.tar.gz"
  sha256 "0974533301ecc7a218175b45f50abad0edf0353ccc55be3a41a3e2bc0968f633"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1770ed6de5f7ae21f35808e299067ca14e7b22d488d4dee597452f5f9f57e77" => :catalina
    sha256 "7387a9ac0d5c6e6bfbb0f0bad852c607d8a04cd732a428253b84870e1298e605" => :mojave
    sha256 "c1c08f48afc87ce9a99708ef21f034703853383fa0bb3424531685957afb7f5f" => :high_sierra
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
