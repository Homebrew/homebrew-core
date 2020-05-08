class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v4.4.0.tar.gz"
  sha256 "29d90973a4abe1b6809176c7f24622aef7be91340ac994f616e8e24afdcc25b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f5983b100db5da8849bc187aeb3165772c23f24beef58d441b411b3fda54ec4" => :catalina
    sha256 "9f73b680e52a099871540606043ca774a9544b05a1caac86606f460754aa8485" => :mojave
    sha256 "a448474e0b0ab6aef9718b449be4979e2394dcf8b141a83ca10f1eaf981cca6a" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on :xcode => :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

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
