class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.0.1.tar.gz"
  sha256 "ebdc36418d876c4d10a065733a46a874e1c1254d80fef1cb60019cffdddd7f6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5058624a6f05744de57484ad118037c61c86b86e1d665ed758b7983f793fe77" => :mojave
    sha256 "11c2f84489bd3c75205d97e8c98a48421f7af50bcb7e0b669dcf3f5d5e9f594d" => :high_sierra
    sha256 "e46d700e89b922ee350910601b70fe16ed638cc9728d629f544525c505da6895" => :sierra
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
