class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.5.0.tar.gz"
  sha256 "200ca32acc7689014250d085808a70368f81706e62ee3773a3baa64d0c3ddf36"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e7d6da05ce0702ebc72947140aeb4cbbedf6c247c9de8e4b599f07ef1418d73a"
    sha256 cellar: :any_skip_relocation, big_sur:       "5625d56ec9f4933c0542e364cfca8fd9dd7a2d2c77309ac5334634b7671096b8"
    sha256 cellar: :any_skip_relocation, catalina:      "44d566761bbc3fec6c6837bdbd95bc5d69480ca7c7fe64193ed11ac47f2406a0"
    sha256 cellar: :any_skip_relocation, mojave:        "703af971b566bb0c040e6ac98447d86eddf7a0b48a54cd318d9093438b25a7d9"
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
