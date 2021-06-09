class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v7.0.1.tar.gz"
  sha256 "47c5dc3cb674b962841e708731defebb5fc2fd9425bde382dbd12ac7ecbbc0da"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4e0c11970d1aa7074249ba22055ad46cf8a1e438e15cd86dd49c2cb222280477"
    sha256 cellar: :any_skip_relocation, big_sur:       "908af0d54fd7c7948d8b987ae8dc7d74c1eb63e0d4df193705b95289bfc2d274"
    sha256 cellar: :any_skip_relocation, catalina:      "9790c78bcc07419629bae49f9658248673814247ef187b531fadee0bae28a077"
    sha256 cellar: :any_skip_relocation, mojave:        "3f41637cc41cdb9867b49a9b17070bc504c54e3be8b97224857fb504bdeb403c"
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
