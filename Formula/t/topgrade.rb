class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.0.2.tar.gz"
  sha256 "9cbaf60a44a1ba76c51d4a44e4fe4e7567ffbbb8c5c3b5751dfbdafd161f8230"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3711a9de21c987b2fd45b218e205a435bb51a37c8468c6bc3676bee097b93be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec7b5ce4782fedb7b20349c41b5d0ba00ed86181b6ba5a5175e0f388ff053686"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "333550890bd5fd0e60c56dbd18022a916e22b385fb0ac3f932a5dfaeca1ef3c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e84b3dfdf890d9d155ed35aaa03a3e6b9b5a854b11e49d42b411cdb255405741"
    sha256 cellar: :any_skip_relocation, ventura:       "fe61bdcd607e5b7519b24fb90e61cd418c46a3ea03033c60ce53bcd7179e52f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1761725332b3296733229bbba291a20cd3a60eac61b259c4c3ecd4c5dbce1a14"
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
