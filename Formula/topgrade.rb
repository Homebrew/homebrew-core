class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.2.0.tar.gz"
  sha256 "4f58bd5f72a17f63cf833d6bf30830116c31cb502f264ad3d22e1f2bd646597d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f991565e63fe2c1bf0e549175f6db56d865744e63311c156663e518555b64f61" => :catalina
    sha256 "4a7175636bfc857225ff4a3b80962c5bf5676b9cfb9513df0057bc6408d9fc3b" => :mojave
    sha256 "af4196b694d2fa53a213331f117175bc046a17435f297e4b874066598eee467a" => :high_sierra
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
