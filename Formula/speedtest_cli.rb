class SpeedtestCli < Formula
  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/v1.0.6.tar.gz"
  sha256 "9ed312e552929241ed090e0c9370801c348e252af89e498034cf4a1ae2aa8aaa"
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
