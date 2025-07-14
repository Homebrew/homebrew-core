class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.0.4.tar.gz"
  sha256 "62cfb4eacfe96ba74d510159812fb87076a31c595efd43eb44cb610ca11f5c9d"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fc6856309e26cf7fdc1e0174f2a26bccd1b91896ce98c532f516f2dd5b8077a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f150cc51df93b3a7cf53b33572eae683cb2fef19c2956c0402e4d9d4910424"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ccab8d3fe475fdbadc7d48b56f50eb9a2d6d5538871d4f1885999c4ee2f8241"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bb5db91784cc41403a1e5470c8434102f555423808894304b7e78b6e3338772"
    sha256 cellar: :any_skip_relocation, ventura:       "21d4365b3877294ff31693581a9c54c5ed17e9e47c6a9828523b6ccfd5b8b613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd9135cc243bad7f9f9dc4ddb1161b41d82641038d93ada736b2ddd5d995fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a07e46192e7d3c7a7b423c527cdc045c787249d94a2a628d6a518cf376f28ace"
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
