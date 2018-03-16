class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v2.0.0.tar.gz"
  sha256 "732daf109a3399c794b293723199d740b0accddef86007a0f85f577bd4ba6c9a"
  head "https://github.com/sivel/speedtest-cli.git"

  bottle :unneeded

  def install
    bin.install "speedtest.py" => "speedtest"
    bin.install_symlink "speedtest" => "speedtest-cli"
    man1.install "speedtest-cli.1"
  end

  test do
    system bin/"speedtest"
  end
end
