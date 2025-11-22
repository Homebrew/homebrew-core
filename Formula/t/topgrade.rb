class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.4.2.tar.gz"
  sha256 "e5a5727b0b33463c913992e05607aecd3157f469c283673f8eca992e9b9c535c"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c82ebaf012d9359ef76bfa301095087aa8e247af3006fede12cae04fc936f6c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7a085ff5c44a1a60ca6e4186282cb42114562e830b417e05b2440b2f980dbe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b848bfae049c0a1819450829eae736057ffd9dada7ad941347fc72597d99485b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a76c0af9c50d16bac007edff707282bf469f176c577e1d871d3e36e800a9e33d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a83086f25ea94b4ec6ea45067aa27b99448d9f1553a4a48e0bbee419cc8a20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88ba6f8f3dbab8c0d2e0aae9c64460f60dc6a6b8c4de896b015fe8094250d275"
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
