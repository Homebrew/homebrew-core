class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v6.9.1.tar.gz"
  sha256 "4cd2a24fcb5f3b9c709b8ff85ff9bdc52afe87735d39f0096e46c57931b5680c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3da7cf504c7a57aea479491572c6ad96d51277726a8974846998d5e25858cd6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8fb57953c72284b268d9978c685a2529ae60b67e9f3b10b516a24605a27d9da6"
    sha256 cellar: :any_skip_relocation, catalina:      "74ef76681d766111efa2cc6320aa1ccf98a40fe74b923349a78449c6ef532e9c"
    sha256 cellar: :any_skip_relocation, mojave:        "3a0ca99c149b1a0f63f5f748564633673a58154e8e947fd8ac208baa24d38446"
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
