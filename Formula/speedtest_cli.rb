class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v1.0.1.tar.gz"
  sha256 "3ec2e6444e309f03d5f56526e6a66e4d556bd95e470abab605ac9c71d8231bc8"
  head "https://github.com/sivel/speedtest-cli.git"

  bottle :unneeded

  def install
    bin.install "speedtest.py" => "speedtest"
    # Previous versions of the formula used "speedtest_cli" and "speedtest-cli"
    bin.install_symlink "speedtest" => "speedtest_cli"
    bin.install_symlink "speedtest" => "speedtest-cli"
    man1.install "speedtest-cli.1"
  end

  test do
    system bin/"speedtest"
  end
end
