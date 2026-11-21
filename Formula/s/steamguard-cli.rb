class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "e17a687a41f99800bc3e7207db75e9f02ee4a4c828cdcc2046e2151e65a16bed"
  license "GPL-3.0-or-later"
  head "https://github.com/dyc3/steamguard-cli.git", branch: "master"

  bottle do
    manifest_sha256 "cac911158b71f502dc7dd72664df4d5173e3312269029da90ffad3809db29e7b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b63e6853efdeb40a27df8910fb2723ec02879d2bc2459d21a658c320e0af2aa5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "819512daf787477ec98ebf3737b0f02cb7b8a5f8438c72f91b14970883332d2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e319654e9083a67eeb077062a1163a6a3d4f5de872644ebf0fa12f63026bfd32"
    sha256 cellar: :any,                 arm64_linux:       "05286651046849ce3818e301cf5adae6e15ac3f58fd0fcc311d0aaa7610a9499"
    sha256 cellar: :any,                 x86_64_linux:      "81c25075673d219af4a6ca9b97ad0ff1fa919b728b37e1a3612ced17bed0aca8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
