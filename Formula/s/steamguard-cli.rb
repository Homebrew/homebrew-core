class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "668e9548643ea6c4f3bf77e7472dafd54386563c6d8589dbb4f72d0f0d1e88f0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "855a2e48950e5057d91ededdd00f5e74e08e7930774e23b87136b1826135c6cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e905a24e271a35a4f4586e98cc38170337f95a25f718b60fbb17d0bc58a35a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0acf0f73cbb7bd2f2818e002fd5b1d0d86546763acc12850ffd28b82ecde0055"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad918ca8a8564f06e32a4bf5d512e57b71ee5a98379e70409e11b13f1dfaae3"
    sha256 cellar: :any_skip_relocation, ventura:       "3a82a4159fb2a3008736f08ac53690854e129759c3cc5602dcae721445c925f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "068720f5cc23421cc1d40c5c195c67e3aafedc1ee41b956e6fddd7de1d3ed38e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b77f1ef0e642fac743166d97d27108f9dc9173c56f2210f28a725c441229296"
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
