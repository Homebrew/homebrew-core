class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.48.0.tar.gz"
  sha256 "23e729ace48ec0bf6d8eff5f99003351463841f3b28fe453faceb62e6f99bae6"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef2640a4e925f13181ec7a56fd8f5e51e0172a166a152a3bc452abee714b7174" => :big_sur
    sha256 "88f7df8f093c0c700998ae44245cd37899c054a3009d1b24404722ca64c0afde" => :catalina
    sha256 "1411ed938013786d86b1c267e14eec81daf4c7ff8a02ee0e0bbf99b1f30b17b2" => :mojave
    sha256 "551d40dac8dbb67a56e6ff643ca61abfa8aa18034e3dd1a6e50368291faf3d9a" => :high_sierra
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
