class Sshw < Formula
  desc "🐝  ssh client wrapper for automatic login"
  homepage "https://github.com/yinheli/sshw"
  url "https://github.com/yinheli/sshw/releases/download/v1.0.2/sshw-darwin-amd64.tar.gz"
  sha256 "4dd11ea34bfcac3c4d318a917557b109c8001bd4157abf6ed7c777c0ada0b48d"

  def install
    bin.install "sshw"
  end

  test do
    system "sshw", "-version"
  end
end
