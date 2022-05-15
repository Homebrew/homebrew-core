class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v9.0.0.tar.gz"
  sha256 "71277152555cfaf1359884a5d094ba841b9b6fc679337871b87476ec5a11c168"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f6563b3c082a921179b30af0e59b2df3a86d7fedcf2fb64945166b5f0691c76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7831e9589ef7360c8a34e1300b89b8aec7be73109d55e93f92ad328bde066cb6"
    sha256 cellar: :any_skip_relocation, monterey:       "a7f55084bc043d824ce30011ce617ccd6f3ce96f366ffdce413642138c40adbf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c429848a1b5ea1d67c23078b24de00a2df7a745a583f426557a2141d26fba32"
    sha256 cellar: :any_skip_relocation, catalina:       "eeb60ffc1bcdcc0fc581354ae6a3c046a4f55c545a8f0a5439af7536709b9f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3191f48d6ec0db5bdb91a62f67a749e762daa5bd4e4d7f2be5e1fddb1c97c7c"
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
