class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.0.1.tar.gz"
  sha256 "454004ea828e5ae35e1a4e8b269e0d85d8fbb924b1c695d8bcaca5ccf92d5bc4"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "c77a9dfea3c3fa533d6062631615b96841a99593d8c1cc6c6e779fa31391154e" => :big_sur
    sha256 "17412fe79d5dab872c66b4e39941e782f202ea357adaa2c3c9260da88d7c15aa" => :catalina
    sha256 "41d62d23e7db85d0bb751310a6973d7b1904de87b50ea61675541dcddfa262a4" => :mojave
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
