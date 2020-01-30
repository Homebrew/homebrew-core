class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v3.9.0.tar.gz"
  sha256 "a74af12257c12ab30937ba357cab9584716e5ca320a8458e2c2cb17589b7cdcf"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c2dd259356d2db4ca03bfe928a45cdd77e2c0d7ea1745af8ea7c6c27d185bf6" => :catalina
    sha256 "9e5519fd59535d1a9c42a27b28e9ca2f89f9aa405f693f00e57d542677cbfa46" => :mojave
    sha256 "ab8195878f1ffdd404c7f33c80a7d31e56b950780ec93675d468908517e6b9d3" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/master/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/master/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
