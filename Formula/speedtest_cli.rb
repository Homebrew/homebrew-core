class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v1.0.5.tar.gz"
  sha256 "0833f09920f072b11a5712a4830755aab0848211a5ed647e0b824e9108422878"
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
