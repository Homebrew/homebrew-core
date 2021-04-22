class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.8.0.tar.gz"
  sha256 "7ed24e5ca728482fc1c862a61e091cb5dfa5353f733c3458fbe1fda662e8fd41"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "502aa7058841f661ea02af5827f46ca9d74ccbd0d7691e7e575f8ebe1bd7eaac"
    sha256 cellar: :any_skip_relocation, big_sur:       "2be3599b1066e57fd41a23e6b364dd64d011403a636315af4a42e96bcd88a34d"
    sha256 cellar: :any_skip_relocation, catalina:      "1e64f966fc9fd7d90462568f44d0a08f4a9ebb4c7ac8a653e988bbe518ef0150"
    sha256 cellar: :any_skip_relocation, mojave:        "c3633a230fe4dd2733460121c2cd2ac73270033557c4dffd48f2d0beca3b7d64"
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
    refute_match(/\sSelf update\s/, output)
  end
end
