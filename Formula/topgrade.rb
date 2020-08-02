class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.4.0.tar.gz"
  sha256 "8a2bb89bf4edc81f4059f13f4585baedfcb6e112bca4197865c70fe1c3dc7be7"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "c89bcd32cbf739da55671cc519b76bcc787a8a77c846e698aea063da3c6a3907" => :catalina
    sha256 "d991dcac0a471d4b0b73e33507f26fc21843634dbf2460a297ea1ada13d8176b" => :mojave
    sha256 "0dd56bcf1cc68fc4a037aa30ee129fda3f2c318205e8556e6627676f668a8848" => :high_sierra
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
