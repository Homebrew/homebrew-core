class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v17.4.0.tar.gz"
  sha256 "97b325d4e17b1b5699090382af2240c70629432da4677400151aae05af38cf64"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f07398776f623de7b96bd8b46d3b4aa1aa468ecdd82652c692064bd96af8340f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "912e2e232ac61f405d02cdb1875d098edafe11b114228f0052bd6525f4338f32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8b1fce0981ea6342b5c83becbfabe935fc905cae041a8d1ef3c84aebd533c3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "34576c6504102ac22a20aafc7eabe5bf33a6e6ebd36c92662ec542f379c43228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0965f22839b782d8dd4dadab404df577d9fa633d638037149008d17e818a869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064b8efbf86cdff5317dd58b21bc1ffb7558ed50656ddb6015200953bcd77419"
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
