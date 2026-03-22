class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "dc02e2a40c5bfc8f28195c99a9575ef10c1fe67f3075d402091e81f53440626d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a075cea4c7595936f22b9454c239a1c915657653242032faa8cdd5afaa1712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1adfdef80cdbf5fb66f54c66d02fe223d80377fca70da7de5485e8021e43c8c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49e799bf9b06cc6316798ab1f1c2102f8d1ef32f327e10afcad9a0b59f940c7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "392352450743b4b7defe304c7601448bbae63dc81cdbdd614ab40c29b3fb2732"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4b364956ebc494e435ab63d2a16885f71d35fa7d99f6a94a299598e24a73c3a"
    sha256 cellar: :any_skip_relocation, ventura:       "1f92c1c691f2f3dad3f3cb596dbc281878c021c9b905aa1d20c10a4e2f0d3c5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29f056815ab5b0055bb09e8b813d2799e3e3a90e0dd0720764ebe65797155d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aab0d522a9b69debbfc758612a4649a00e221567065b311b745bc7f9342d9d50"
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
