class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v2.1.3.tar.gz"
  sha256 "45e3ca21c3ce3c339646100de18db8a26a27d240c29f1c9e07b6c13995a969be"
  license "Apache-2.0"
  head "https://github.com/sivel/speedtest-cli.git"

  def install
    bin.install "speedtest.py" => "speedtest"
    bin.install_symlink "speedtest" => "speedtest-cli"
    man1.install "speedtest-cli.1"
  end

  test do
    system bin/"speedtest"
  end
end
