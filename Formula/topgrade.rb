class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.0.0.tar.gz"
  sha256 "dae2a6e95521a8f6bb42888a7de70e2e065ac2679fc07f033b5195be12f4456d"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf2a682b0049a8a97bc81b03f04febea57a2f5867f44de43af02023997d36bb7" => :big_sur
    sha256 "c2c5d73810f31e2953d42efcc364a922d81396e6b18e5894b5df75b9502815e6" => :catalina
    sha256 "1e8755419e934d76ed7ddc179986a87f22980163afd65abe1ea88891d89a5119" => :mojave
    sha256 "f213534b8ee0d27eb358b2cb106efbc450641907a6788d849508b5b11a0a5749" => :high_sierra
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
