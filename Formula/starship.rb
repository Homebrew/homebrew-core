class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.10.2.tar.gz"
  sha256 "b3833c3b23906db778bd0d9a7d87ed232745739e47ce59bcfa8e92c7f0f930e9"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327b8a1be38939af3aaf9fc4db794c8a43dd0b21a23f3aaff76370df518f1126"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dfa9a213f99582f86b894a9cae80482a3e10bd6e36975af6fdf4cac139365e2"
    sha256 cellar: :any_skip_relocation, monterey:       "b61447477a564b4828afd764074f41b0ab7631df0fa0bbb5badb29b42fe1e6ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "237231ec5762a53219db291533b1404c27e7f6258a8b8aa8db23653b0827e220"
    sha256 cellar: :any_skip_relocation, catalina:       "c285e04fba5ab6eef694d12b16f5833a34f7da3c7e6f57c45ab9e26249a4f9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cd47a00659f213af4d9efa61ab3081d0e486cb7b7394aed3b1768f2d47003a"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

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
