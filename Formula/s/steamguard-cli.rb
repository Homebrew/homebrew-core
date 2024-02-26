class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "23fd9653826b2f3706203c2aaf9db8aed468821156b4dfc322b258fd8d7e1429"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d8554ae75a900c3edadef27443d33514d9eb92600d7cd38bf5dfe3a9e51f555"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39b4b1287da3aec6df239fbccb5e49e5e381b62005666e80dbf4b322353626b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "593ddc9468ea738bfacd32005d0107dffc9ee4a17e8556e0ebab58b34cddd829"
    sha256 cellar: :any_skip_relocation, sonoma:         "5586666e84edf6057177e3392d67a9e8a928a14ca6225a16f3c76ac0d73e5265"
    sha256 cellar: :any_skip_relocation, ventura:        "7e442fb7c322694e458135a96862317c7ab5d705aa23927f625a21888d170c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "172195696b5b58ee1011f32bae2fc13a26b7aa1aad3b9e55ed5998501b93529e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "546ab1e1bbd19992adfd3f674bc7386fd0ce53a9965bba82e8bce6838d91de11"
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
