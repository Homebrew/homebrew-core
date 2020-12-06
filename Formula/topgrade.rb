class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.0.2.tar.gz"
  sha256 "c06ebb0e2c4b2b49751c4ba7cfb8ce4ec7fe2f9247faac3edd4256c215c8bfba"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d45671df2770cb74422783e3c788af7bb3997bca069f7074a3e69e34ff197eb" => :big_sur
    sha256 "4489dcfa01a2f6ad088336a47b9724eefb71e8b78aa188f80aad6712f7ad44d6" => :catalina
    sha256 "117405a06e4ae6cc8871b1c360be5e11155bb2964ea8d4c1d5118fb3874f664a" => :mojave
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
