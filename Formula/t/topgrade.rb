class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v15.0.0.tar.gz"
  sha256 "53c6521041a6ffddf1ccb13f404f131919a2ef48deb3974fc71dc3be08db6cd0"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a17876bc268b32264706ce0768d126f1e87062259e7920b5856eda0fe6f333c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bc4ae08ea5128a90c9b231f06c1fd6a871efeeca9880c8d15f664c3216b01e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9f1a51fb7c05c5952220c9eef82a4d28b87d64e2036fad148aacd232e6e7af1"
    sha256 cellar: :any_skip_relocation, sonoma:         "fec96b7c87ab4abb423a1cb41cea81d2fe226a595fba6f1e03e731cc264a4d6f"
    sha256 cellar: :any_skip_relocation, ventura:        "2c35b56e4d8806e003b882972bb41febb181d3f5631fcbcb2da231550a8a2599"
    sha256 cellar: :any_skip_relocation, monterey:       "ab5883ebfafb6a25c7f2e571d5e02335a42572aa00ae8e8a12d43a9ae64f7369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3e41f16305e24be1634500dbee353578ffad71e46e211135afac6418cd6659"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"topgrade", "--gen-completion")
    (man1/"topgrade.1").write Utils.safe_popen_read(bin/"topgrade", "--gen-manpage")
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}/bin/)?brew upgrade}o, output
    refute_match(/\sSelf update\s/, output)
  end
end
