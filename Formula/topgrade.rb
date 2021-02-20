class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.5.2.tar.gz"
  sha256 "e7107ee2ebf87e09641c1555d56a1165d53eb8ffcfcbb04345d27cee6ec0c6f9"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "639d9433000dbd612fae89e43c67d62b6cabdcd31feea2eb7a9231683ac32aa8"
    sha256 cellar: :any_skip_relocation, big_sur:       "829f04fa843f3e3f0750b4c457b50dcf46849d0e5d793b7cfa36a7b07a8ccbc1"
    sha256 cellar: :any_skip_relocation, catalina:      "b0f5756a5b3034ad763c93775f675abd6f2d499402795f462d87e85ab23f2ebc"
    sha256 cellar: :any_skip_relocation, mojave:        "dba692c1753c2bb6256c76f98b6fb5657e15bbcbe749ab50dea4a59eea38247e"
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
    assert_not_match(/\sSelf update\s/, output)
  end
end
