class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.3.2.tar.gz"
  sha256 "2a4fbafecadba9c7df94b0a39756dc23bb0e36fb066778cf8df8c29c7be1569e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "721e3bf97251b6f87f74f544de588665551ca8cde796cc3892c4c09930dcd647"
    sha256 cellar: :any_skip_relocation, big_sur:       "d22afeb0ce41bb904c578d0937769106c4238786f2f1e99049a09acdc3e4c970"
    sha256 cellar: :any_skip_relocation, catalina:      "0ced5032bb268646ed019ea9ee8ada679015b1cdfb3e7f1080d68c55c9efd63e"
    sha256 cellar: :any_skip_relocation, mojave:        "03df4f3f862729424b4fa9d874b46c9b0ca65cf2ea4b9145cf4517595a0fdeda"
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
