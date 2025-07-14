class SpeedtestCli < Formula
  include Language::Python::Shebang

  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "45e3ca21c3ce3c339646100de18db8a26a27d240c29f1c9e07b6c13995a969be"
  license "Apache-2.0"
  revision 1
  head "https://github.com/sivel/speedtest-cli.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "6add96ed8b9a4a517bbbe21659fb0068c4d6b11da84d858524d221eee60d8448"
  end

  depends_on "python@3.13"

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/sivel/speedtest-cli/commit/22210ca35228f0bbcef75a7c14587c4ecb875ab4.patch?full_index=1"
    sha256 "d0456eb9fded20fb1580dbc6e3bc451a10c3fbcd3441efea66035aa848440c09"
  end

  def install
    rewrite_shebang detected_python_shebang, "speedtest.py"
    bin.install "speedtest.py" => "speedtest"
    bin.install_symlink "speedtest" => "speedtest-cli"
    man1.install "speedtest-cli.1"
  end

  test do
    assert_match "speedtest-cli",
                 shell_output(bin/"speedtest --version")
    assert_match "Command line interface for testing internet bandwidth using speedtest.net",
                 shell_output(bin/"speedtest --help")
  end
end
