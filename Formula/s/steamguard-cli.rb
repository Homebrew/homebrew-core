class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "3df79d0263a6c60c0cdde09c341d994776d7236216e460ebf958d6285c4ab0b6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "905e0bbc74de46482bee72f08fd25206f09db4e7341f1a015ff1d0a154394d71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d659e54a97bb33c52098b70b751967ea07fbdd8f6efd859dc35f692049c7c954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5116432f9e920cdf2c13578e9ab96d62e5ef17455ec44382160eb75d6a46389"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed24b5d6447d90e352f06f6d26472828196a624336509d3b748f20da99c59bba"
    sha256 cellar: :any_skip_relocation, ventura:        "68a28833aee6dccb02eb523a611685546ba58806ab66f6b1937338e81ebbf863"
    sha256 cellar: :any_skip_relocation, monterey:       "dd4f1ffc51b2ae41330bc56af79bf2933bedb0ef8bf2595f8581db586309d664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "012a61bf518d24a2274a194edfd91015883da85923080f3aa2c469e0dd5c77d4"
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
