class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "cc0c52bb3dd0a325d11575475e54bb959a3cbdc346e5545052e1b0a21de7f16f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bd61f6325f83181d7419eeb04eeb4cae8939b0b68515602fa726afe94945f20a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a8c60208bc0aa1284cf16fe3fff855526e37b72aea0e567cb660ba0ca055f3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "013543ca85a7661ba9e8bda15f761c297e3e43d4055e74895cee12174ce61bab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7b7007cf9de36c9e105bbf34bafbf24b3ef7a373081ebf8b28096ed5c13817c"
    sha256 cellar: :any_skip_relocation, sonoma:         "33854f4084e1ec4c8d70f9e8f0c9e77a9979d1eaa97e30821d348b96c851cfa7"
    sha256 cellar: :any_skip_relocation, ventura:        "ef85b88ca1f677a0ebd452b001957413f2ff1bfdd3de11e6be294d96cf5fe0e9"
    sha256 cellar: :any_skip_relocation, monterey:       "e19c7d3f838cdc5a09d6ca8f0e50452f110967ee78ae375ae008bb8f6d0f0844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a4f909c214af20ed9a0e8e08886e901c573d10629348220850bfb3204f7251d"
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
