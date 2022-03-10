class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.4.1.tar.gz"
  sha256 "3ba4e9935bfbb4c8b8fb18dcc73c0c9eda586a413b9d3f3378de4b095cb5f87a"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a22d6e157c9e4d145b66b8e50eda2b133254a68cfd48c07f03a549c37199585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23885f5723f423f97453df4302f8c23c8e13c018aa7c9525e2d17509e55e3e2e"
    sha256 cellar: :any_skip_relocation, monterey:       "406f9e2d490495251a2b197586274f7d52bf2dff07e13117f44785972d25430b"
    sha256 cellar: :any_skip_relocation, big_sur:        "74054b14a109eeec43fff2f942440c9f8b56d54b71e21e37a80c3138007d38ac"
    sha256 cellar: :any_skip_relocation, catalina:       "92d27f7541b888132a1dc7bb1b6fcce59363d075a46b78549dfd5f1156aacb57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "375f4d44924df3916d08039a7b98f01a665598fdd7cfefafd04b079251602d61"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

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
