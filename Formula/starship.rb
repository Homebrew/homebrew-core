class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.2.0.tar.gz"
  sha256 "4b10562954e42e8e75b1a82fbe9484b8126735e610d8aec3366c7a98651e5898"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "902bcac86e8fd52688e4357f106cc615cb5dbe2128d280e5162f999950191991"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3276f4838f206e648ab54f3de79d53c8ac43ac0b78e3c8f71cb9dd818c5cd8a3"
    sha256 cellar: :any_skip_relocation, monterey:       "1f46babd20f46071b4922ab42398892da75d7c8effc2a10982cd986bb388967d"
    sha256 cellar: :any_skip_relocation, big_sur:        "08407c5327e05ba055a8850a2e4fd0305aa5ceca38ccf18365081f9a3f90db7f"
    sha256 cellar: :any_skip_relocation, catalina:       "8cd2106df217857b8c84f5c985aceb1ec8a38452b7508fb4c8755fef8139f209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4106eb634f80c93db71c23e292293034f996ecc24d99735ddec9a7450c0cc73f"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", "--features", "notify-rust", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
