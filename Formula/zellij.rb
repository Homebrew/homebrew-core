class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.15.0.tar.gz"
  sha256 "e8f3f190d75b89050ca7a85114ddb80aa8f03af66376452bbd5ed5c412a94e76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3bd9acb0bba9cf1a1643b542b0538f348fa9c7dcf07b837d98e1fb1a35addb10"
    sha256 cellar: :any_skip_relocation, big_sur:       "e64343d119216285d1bb140833d2338eb80ee3647698385e7c9891e3defd6648"
    sha256 cellar: :any_skip_relocation, catalina:      "5c73240ff871ff33ac392a9226ad04af741bce6b3ca7564b2e504d45b45e26d7"
    sha256 cellar: :any_skip_relocation, mojave:        "581dfcfd32ee0e13586a727034edd662840bfa2083c45bbe54c0adfda692751a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "303deeaf282db77d59a89a3186351011b3aa213652c21411e8b26b8fbb4bb23d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "bash")
    (bash_completion/"zellij").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "zsh")
    (zsh_completion/"_zellij").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "fish")
    (fish_completion/"zellij.fish").write fish_output
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
