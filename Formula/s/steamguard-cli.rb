class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "fce353371010cbc298e6dc2d7063742178639eb90127b752d85c3cf92a46661d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bda7303944afd413d8192f4fec2558195db94e615eee4d4ee9cffc5d518658f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4afa0b6d691206b08f9a6c2cd8d16ba011c7e3ab287b1ff42f549af80f0b3ff6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2d7621a33a6fb4e05d8e7a1d46b4d879997c928536475078fb2791f193fb771"
    sha256 cellar: :any_skip_relocation, sonoma:         "0580f30771825f1e5ab95eb2c0040c9be89b9ac4d4f56cfa9b2fc909b4aa2d3f"
    sha256 cellar: :any_skip_relocation, ventura:        "c9b03301b1be7459347262ed43a6e2e54df1e3571adadd21d10617dbc290e8b3"
    sha256 cellar: :any_skip_relocation, monterey:       "bfd5444d21d05082cd805d4f7a1d0ede847bb2602679fbc6fe4051aeb4ed924a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50b8e283664451fe4919525c4bccbf455f31bf200e832532aa73937bb840ef4a"
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
