class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.48.0.tar.gz"
  sha256 "23e729ace48ec0bf6d8eff5f99003351463841f3b28fe453faceb62e6f99bae6"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "461f362c2c7227f3c7637d503f0b6f9db83d412b0a24f7c200c03ee4790d972b" => :big_sur
    sha256 "3a4b46b0f49633a4fdca52a1acfabc3a54391cfda42e0a8178650b17f292d7b0" => :arm64_big_sur
    sha256 "7fb2b5de13a54a767b0357f0587cafd711d93091d7c2739b90799590a8c6410d" => :catalina
    sha256 "3f342da1242f3be6eb2e59e2bf7bec51d2caf77c6f5119ccd5f0f7634af57598" => :mojave
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
