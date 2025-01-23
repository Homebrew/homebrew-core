class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "0dc655447a1fdd10edfdd5e3abfffcbbd7d4fb779c5ee10c007e7928404eeabb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bc2fea7ba9eda272a82ad0753cc5bcfbaee5dae66cdfc02eeaa05abfc994846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fe36fe5920f16f359e910b05f65613d09d830076253443aebdf64577c588067"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5865c2d041ce521b21d9086fad28d5b70e6d437e86a447f2d232b3e18614e9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b94b9a702865492c969cf80319e36a257b94cac391679445ba23262aa915949f"
    sha256 cellar: :any_skip_relocation, ventura:       "a49f95cffbc3c033120433feceb2def215df26eec50d3beb30419f7fe5c57d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6e0f24ddb3c2163f20feb6298ef557bce4d9ed3bb3ec0e16452d8f9b20fec5"
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
