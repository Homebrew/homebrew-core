class Rmux < Formula
  desc "Terminal multiplexer with a tmux-style CLI and daemon runtime"
  homepage "https://rmux.io"
  url "https://static.crates.io/crates/rmux/rmux-0.9.0.crate"
  sha256 "7ff199e13aef3409816803c5a6ac06720fb710fdf6165bed4d36daa090b5fac8"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80828c5deeefa13da7228c44edb139b8a9dc014ab8cfd236a9c0dac3e5e8923b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e191e0c0b7f45a2319fa0d2594f12a4b482adb7127e57f8b59af36e2c7870904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "032fe1b9d13528250abcf0ad8c6baf325772a38b0cd83a498887aa82efe881ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "b16253ea83492c514c76817a750fabf6839d0f1decc321c3bea6bf35bd94d310"
    sha256 cellar: :any,                 arm64_linux:   "1e509bd4c4c2813d6eed2054077b536818ec4437db2d0ae6119f9c1cb3cd113f"
    sha256 cellar: :any,                 x86_64_linux:  "c46b2e4c7b89de297d09294aa3dce5e67f3198d92f97fb66e261a0b065c21461"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/man/rmux.1"
  end

  test do
    require "json"

    assert_match "rmux #{version}", shell_output("#{bin}/rmux -V")
    diagnostics = JSON.parse(shell_output("#{bin}/rmux diagnose --json"))
    assert_equal version.to_s, diagnostics.fetch("version")
  end
end
