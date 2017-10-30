class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v1.0.7.tar.gz"
  sha256 "3853bb7a3d16f686441d0d10ebbfc1fd49e974ecf17248ce03456ad4ef2478b9"
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
