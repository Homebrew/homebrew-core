class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.1.0.tar.gz"
  sha256 "801bec18bf3b9fd3dfa9f8343864e10dd47edae8a1d86a186d9c33a77af2608c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddcd18f958b79d32fb2a59085c2975dd0060bbb30a988558442c3aaf5f9b60b5" => :catalina
    sha256 "38bf744a84712e9433015d7e38e594b3185a2c0d5470894db054b3114eaa4290" => :mojave
    sha256 "29397cf0bf84c7d8cc8f30de215761bea57a50b7885961e2f52308fcf405c756" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
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
