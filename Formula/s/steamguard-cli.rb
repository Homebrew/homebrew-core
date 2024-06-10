class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "ff4a80355cba37339dbf3e31edd3ce5f11593a25c8d162d4485a6b8d8414fdb8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54b977e3deb04e93c916476aa3cd3cd0038531a0e71d94f897eed945bcd591c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2d45ab8c4615603233b6795018e1b25898baa80802bbd640104efe82ba2e243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308fe41710ed5af7a6aed5ba505494e864e0fc6f636f6a194f7517314c9b2468"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbbf5f2fe08c14f7c86626414b236a3ac7763f2bb9e1825c99b773c6417a6170"
    sha256 cellar: :any_skip_relocation, ventura:        "cfb427f37153bc573cbaf3c3c1c4eede1b275ed1f81ef2f120d5ed9f6d9dee20"
    sha256 cellar: :any_skip_relocation, monterey:       "36423f3be39f9d6e25c5c69b6f940b97c4febfecf4084ed3ab2ab9e4a8f985f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec8c3bd9bdf8dd173bcfc4bb052c8cc20f4987c6f81d40bf80764cb515c5e5d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"steamguard", "completion", shell_parameter_format: :arg)
  end

  test do
    require "pty"
    PTY.spawn(bin/"steamguard") do |stdout, stdin, _pid|
      stdin.puts "n\n"
      assert_match "Would you like to create a manifest in", stdout.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end
