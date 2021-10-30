class Trinsic < Formula
  desc "Command-line interface for Trinsic Ecosystems APIs"
  homepage "https://docs-v2.trinsic.id/"
  url "https://github.com/trinsic-id/sdk/releases/download/v1.0.1/cli-1.0.0.tar.gz"
  sha256 "35f1b17cd80ef52dd8e628380c7401bc1b8e818b63033cce0d5ad328558a71a6"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    config_toml = shell_output "#{bin}/trinsic config --show"

    assert config_toml.downcase[".trinsic/config.toml"]
    assert config_toml.downcase["[server]"]
  end
end
