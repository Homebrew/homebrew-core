class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.0.0.tar.gz"
  sha256 "a66d47758b3dac4f1a626bb175c4847a2ef266540498a9f25222e715baf9f9db"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35fd536521a8c741c86ada03b75e22dd08f719dbde5892c25d32d3ff67f47bc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b13cbcb4e50e836f17e168da533c767a38ed9ca95a78a0982317705c79ffa149"
    sha256 cellar: :any_skip_relocation, monterey:       "5f9d73aa8caa8dc009958d9ae2df016ddc4e80e97d75d9aaabbdf800012e5efd"
    sha256 cellar: :any_skip_relocation, big_sur:        "107b6540bdb4820c59e0e022b12e9c3020a3f17f3d428c4aa7229fa2126d02f4"
    sha256 cellar: :any_skip_relocation, catalina:       "aafc54465ee3a673318edb08039c0eb3b37d3c42407e534498ebd0890bb8d3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99000a25be0ea6411caff418a2bdb2dc30122900fbddcf0c1a9431bd4d00417b"
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
