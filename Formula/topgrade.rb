class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.2.0.tar.gz"
  sha256 "4f58bd5f72a17f63cf833d6bf30830116c31cb502f264ad3d22e1f2bd646597d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6a5f6f193790d0ac04b1ad2439bcdd4e6e59cff37297069260017f2a894543c" => :catalina
    sha256 "f1f1c84d43b08229033d2ffd95e64f1a38df81d204ccf813c272145c080cb595" => :mojave
    sha256 "6fa8bd2a4f9e2bf57549a5f61bd02b628a9f8154bab15ab80531e91004b5b661" => :high_sierra
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
