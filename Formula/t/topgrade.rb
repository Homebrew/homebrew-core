class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.5.1.tar.gz"
  sha256 "bdb4b70319c74ebbe3266d6394963b7798b1362a0a035dff27bec0618ae09c38"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "053574bada7c4f377e8d87c7b8191f2513416a1cc3d9a125ab8cbddfe9e58221"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fdad016cc090023fc41990fba63f91e73603b2c46704bfc1f2e49118a102447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11013feb693d3d158b0fcab0e1d8ef5d63dce86bb9deeb7f61966ddb5600842e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3801cc40986566fa30d5bd660936436757d69b4776733d6f8751491cdc4a1cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdad37508c7f32dc310dad9dab91f6dba4c3763502c4afd6a4ad7f3e6aa222c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a46a9ff94dac255ad18f3262eb1880598465fae8217dd468ba9199fa24e0cfc0"
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
