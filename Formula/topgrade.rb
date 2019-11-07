class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.3.0.tar.gz"
  sha256 "22f8065d3fe715726de400927f845323b66e93ca374fbb3b6276289f83052384"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cf9bedbabe700a3e3569f3b8abd350d7580a09c71c14c6008179022536cda8b8" => :catalina
    sha256 "fe4edeba7017eeb5dd11abc43428b5a10a09fde684f053377d34756167294462" => :mojave
    sha256 "d5c5ddb284bd5b9525a04aeb095bdf921aa441233ae3b9418d8f152820e069f8" => :high_sierra
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
