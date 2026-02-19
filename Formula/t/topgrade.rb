class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/topgrade-rs/topgrade"
  url "https://github.com/topgrade-rs/topgrade/archive/refs/tags/v16.9.0.tar.gz"
  sha256 "d6e8376c6363545ce8994703c33f18d50fb4f8c689a2bc196bed159010c9cf03"
  license "GPL-3.0-or-later"
  head "https://github.com/topgrade-rs/topgrade.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "025767e3079058659ccf1c299531998ab4aba438a55afcd0f71a8c63ca19b40f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d061a11feac89bbebea6a7ad76994258b4eadb35b7b345ae252254f49819cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4e8530296b8b5f17ca2c6a4c5f507c2a27cfdbac7b5ffbc852f7f6c9cd4a96c"
    sha256 cellar: :any_skip_relocation, sonoma:        "98587b041864f41992c0e2ae4cd67239b33de2f658ba462a8d0242b19ca071cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb3f6c22c2d0b1651397c31f2a90934f3d1ae9ebfa65294eb10ebdd2bde6c640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a652853680572535734e7afe43250ce4ab38173ba8d78ffbfc5239044da4fc"
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
