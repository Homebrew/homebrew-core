class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.6.2.tar.gz"
  sha256 "173204e8a1d051d982244899c18da35f55cd9574244c27582281bb74216bccbe"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ff25ccad5c1501225e96d9844cb86f9c529bfa0b1a1a9c1af68fad6bf49f218"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cb3b2a8d53069da5282f475b4ca3b6cf166f5f94ca9bd93e3a8d14b23445532"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9bd0dc1629e1c75d168c61eb252674a4a8b83df55c065bf4b3d40028519adc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a6c5993d1dc6549e491aee70d89dc5ae6b72551ede5f2fba3b3a8377a121df"
    sha256 cellar: :any,                 arm64_linux:   "20b2d47ce3bab55391e8346a55e82caac0d6cbc3657d8c96ab1ee27bd5f80ec3"
    sha256 cellar: :any,                 x86_64_linux:  "a6bafbe062db9cdf749c08226daf7887e71cd6e9e555c0892cd2f0108c3e27b5"
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
