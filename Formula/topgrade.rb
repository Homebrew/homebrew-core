class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v8.3.0.tar.gz"
  sha256 "a818cbdc64aafe77a589299d5717988fd5e5403af0998a9945b9d17a5b6f499b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea0b2ef10e1dd2875e10b2adc940fe1afda9eafb7757feba50a6afcceb7c065c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87020ea515d4f51e67e0c0df3b80a50f787c79708bb752bf44083ea00272f035"
    sha256 cellar: :any_skip_relocation, monterey:       "5fe4a8b351db46efa12f98781fed1acf8705f9846e89d457ea712e43d2b494f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab9e955518844bdb34c01d1e5331825146cf75f395f08c8a5f29dbeba0e3f32c"
    sha256 cellar: :any_skip_relocation, catalina:       "3effde42f63353395c69a41300e5b4108d73b5276189d000d6119d3f486a97ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76aac7b5595c1ef680d263e7d327998053cee7ecac865205a72ddc0bcc728f8a"
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
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
