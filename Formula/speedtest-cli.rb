class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v2.1.1.tar.gz"
  sha256 "433675c19bd40c059da5d98c512874742405e8185afed47f8aa11a02ac61aa06"
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
