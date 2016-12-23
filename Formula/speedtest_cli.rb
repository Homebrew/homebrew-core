class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v1.0.0.tar.gz"
  sha256 "c9692ae3ec2005f39830ef8e645f63ccf45d6797624b5a56a53bde4d2174edca"
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
