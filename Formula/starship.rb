class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.50.0.tar.gz"
  sha256 "d8f4dc9bd266f2a5c34926d361c62fdddb61cd7da4acadba5f9c175eb07602e5"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "fc5a31682addd09df1113aedc72b0cb7b3403871296e224192af2d69f7e37662"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8837a13ce7325538308d5acbcd5754a9d8c41eaa83fbccfdc4fbb411f7aa3844"
    sha256 cellar: :any_skip_relocation, catalina: "b34251daa655a23c7508a5dbd12dcbe82d1eab9cef829480e90f0584c01b6f90"
    sha256 cellar: :any_skip_relocation, mojave: "2f26c9a5de36e7d023f993e7be082eb2bcf2e52ee2bd0361e66abf4f917c9164"
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
