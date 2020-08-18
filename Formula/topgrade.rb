class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.5.0.tar.gz"
  sha256 "73c33f86cac8301c177be6215baaf800c79c2305ee811f0c880b6604f81ece55"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "7feb5b2582864fcad69bc545317a16b3034e3df88e9fb5b52c7f74f4c6fff9e5" => :catalina
    sha256 "fdcaee4ecaee9d389cfa7368abf9a494228228e24054d0e72fba49796a4ef21e" => :mojave
    sha256 "ed54fdee85d451c19b564db4a9c43df44851154e1d810d227e68f1eb9a2fc14a" => :high_sierra
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
