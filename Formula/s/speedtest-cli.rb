class SpeedtestCli < Formula
  include Language::Python::Shebang

  desc "Command-line interface for https://speedtest.net bandwidth tests"
  homepage "https://github.com/sivel/speedtest-cli"
  url "https://github.com/sivel/speedtest-cli/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "45e3ca21c3ce3c339646100de18db8a26a27d240c29f1c9e07b6c13995a969be"
  license "Apache-2.0"
  revision 2
  head "https://github.com/sivel/speedtest-cli.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "93487be757c9b3763deeb1b1415ee8ad10c5a80fcc9ebaeacbb8fbac3e9b9474"
  end

  depends_on "python@3.14"

  # Support Python 3.10, remove on next release
  patch do
    url "https://github.com/sivel/speedtest-cli/commit/22210ca35228f0bbcef75a7c14587c4ecb875ab4.patch?full_index=1"
    sha256 "d0456eb9fded20fb1580dbc6e3bc451a10c3fbcd3441efea66035aa848440c09"
  end

  # Replace deprecated `datetime.datetime.utcnow()` function with supported
  # `datetime.datetime.now(datetime.UTC)`
  #
  # https://github.com/sivel/speedtest-cli/pull/808
  patch do
    url "https://github.com/sivel/speedtest-cli/commit/305dce9bd28e797d32b6b7e4a9239a669ab35322.patch?full_index=1"
    sha256 "468f7205cedcef51eb95eb565db56d08743c5663b1641be62d9d1247d0845f3b"
  end

  def install
    rewrite_shebang detected_python_shebang, "speedtest.py"
    bin.install "speedtest.py" => "speedtest"
    bin.install_symlink "speedtest" => "speedtest-cli"
    man1.install "speedtest-cli.1"
  end

  test do
    assert_match "speedtest-cli",
                 shell_output("#{bin}/speedtest --version")
    assert_match "Command line interface for testing internet bandwidth using speedtest.net",
                 shell_output("#{bin}/speedtest --help")
  end
end
