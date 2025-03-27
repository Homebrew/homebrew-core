class Tinfoil < Formula
  desc "CLI tool for secrets management"
  homepage "https://github.com/tinfoilsh/tinfoil-cli"
  version "0.0.8"
  license "GPL-3.0-or-later"

  if Hardware::CPU.intel?
    url "https://github.com/tinfoilsh/tinfoil-cli/releases/download/v0.0.8/tinfoil-cli_0.0.8_darwin_amd64.tar.gz"
    sha256 "2a1b6fcc311571374bd6fb1bd0fffaa856cc68234688d4d98c03c9b1cef74be8"
  else
    url "https://github.com/tinfoilsh/tinfoil-cli/releases/download/v0.0.8/tinfoil-cli_0.0.8_darwin_arm64.tar.gz"
    sha256 "b2837a13ed34e78f69130c35047e5b261ae3bd003815065d3737ec0cc849b37a"
  end

  def install
    bin.install "tinfoil"
  end

  test do
    output = shell_output("#{bin}/tinfoil --help")
    assert_match "Usage", output
  end
end
