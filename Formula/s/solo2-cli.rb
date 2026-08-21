class Solo2Cli < Formula
  desc "CLI to update and use Solo 2 security keys"
  homepage "https://solokeys.com/"
  url "https://github.com/solokeys/solo2-cli/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "49a30c5ee6f38be968a520089741f8b936099611e98e6bf2b25d05e5e9335fb4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/solokeys/solo2-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56e93747406fb09f278a2dc2506e8006c5105744580b3af8c65d83e5df2f675a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50ee660ad214d9fa3cf5e103ae11482ca620796956e8d8e4ddc862c60ffa8a13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54b51487dab6b1f46921c3a2ac5abbdd0a7c26ee3fa588c1192d329c37c481d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd347d17f99e031793c283d4d161eda583ce6807a2fc8a7ec9b13a0a01bf59fd"
    sha256 cellar: :any,                 arm64_linux:   "49fa148943abb5f308b98439a3658dd23c9a0ae52531b732033c40def49d7667"
    sha256 cellar: :any,                 x86_64_linux:  "30961888e19a8438a16527313659240b9a16bca8e60b543b80d90a9f22274c0b"
  end

  deprecate! date: "2026-07-24", because: :repo_archived
  disable! date: "2027-01-24", because: :repo_archived

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pcsc-lite"
    depends_on "systemd"
  end

  # rust 1.79.0 build patch, upstream pr ref, https://github.com/solokeys/solo2-cli/pull/122
  patch do
    url "https://github.com/solokeys/solo2-cli/commit/c4b3f28062860c914f3922ad58604f0bc36ead93.patch?full_index=1"
    sha256 "1f3e08c4c6f17022e8762852ef8e2de94e1c0161d4409d60e5b04f23d72b632d"
    type :unofficial
    resolves "https://github.com/solokeys/solo2-cli/pull/122"
  end

  def install
    system "cargo", "install", "--all-features", *std_cargo_args

    bash_completion.install "target/release/solo2.bash" => "solo2"
    fish_completion.install "target/release/solo2.fish"
    zsh_completion.install "target/release/_solo2"
  end

  test do
    assert_empty shell_output("#{bin}/solo2 ls")
    assert_match version.to_s, shell_output("#{bin}/solo2 --version")
  end
end
