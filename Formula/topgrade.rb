class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.8.0.tar.gz"
  sha256 "64217a832060e3b259d20c3b72d3b7a56174fbb84de5ec8773e00819b604f413"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccc3813677783ed52b9485a0a355fc6effa0a94c3f8eeb8be56ddf4fb9459b83" => :catalina
    sha256 "7c1611ee6f6f6bffc822f3c6065e4219e65719e47704895094d74951eea14e4d" => :mojave
    sha256 "64e52bb5908766e55cf1591c939a00d69844da33668f9b59d46d4fb6f01ceae6" => :high_sierra
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
