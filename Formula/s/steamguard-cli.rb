class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.18.4.tar.gz"
  sha256 "a1beea2c0626ccda8a92abccd27fcb78b78a83d79f973095c972b913e088fdca"
  license "GPL-3.0-or-later"
  head "https://github.com/dyc3/steamguard-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "866991f4513fbbcb4406b51cc4e0c489f593a145e929dd0b9ee1c04085e04a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc99a69485e57da5365215151023a8a0e09b6e14206852e9c3747688d54871cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d4f9238e4222a94a2eae7568f19a8c473d7a93715bfd6fc0d3379266dd74cf9"
    sha256 cellar: :any_skip_relocation, sonoma:        "b821b26453627c31eafd253d91bca05fecf6c6dfc124c44a1992621fc7289b4b"
    sha256 cellar: :any,                 arm64_linux:   "7390563e85f6a2adefea42b499da8cc0a4ef53831f284918a98ac5afe5c7bc77"
    sha256 cellar: :any,                 x86_64_linux:  "1149454e1978b5544ec8dd3b52d7d258b0a4300651f87b00148efbee58418c86"
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
