class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.3.0.tar.gz"
  sha256 "0b409017848217ce422f6897956da03fa82041fcbb0052b645a8ca3b595c6c97"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "947b4a2f95b153fe6d36164265d9701ecd31ee6508bba9368eea1ef634ec39f9" => :big_sur
    sha256 "cade9faf92ce5fae797590a4ffb8b38954964133d266b6593bc3777aed57d875" => :arm64_big_sur
    sha256 "dc61b0277bc66618f1b560d1336b543d4b2ec8f468833abd33663eecf7ee7ba9" => :catalina
    sha256 "8b0f26d1e7eb8859bc1a0023ed89bde3d5fbdbd31591ce5a3922a49bf3021829" => :mojave
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuration path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
