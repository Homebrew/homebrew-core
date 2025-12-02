class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/refs/tags/1.2.0.tar.gz"
  sha256 "cafc57b2f2e29f204c00842541691038abcc4e639dd78485f9c042c93335f286"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b614420f313bdc3e60321943dec593d6baea0d75dff36d25a6152d283f5f5f5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d021a20a2281bc21cc5e1512fc566d655403d2e807b65108998766d9f2439db5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45818d930ab0aa766ddfbea6a15857d3e39c19dd78e86618cfd891ea30695d8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3289f914e422c1ada3312a27103e11a726b22ad5e1a473171f8aa4abe798be04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e31bfc35f96c00b8baad80a700475f277a1882d7cf888708eaab2f2cf01651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "935d6a0ac05fc9c2eba6252a8d229bfcfacc45a0ced4350adf6012f1028228ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "ede908c9c08b0034f3fef47e62c35dd0ae12581a531f6abc67b03c7de92d348c"
    sha256 cellar: :any_skip_relocation, ventura:        "67d3ff596d0ca68ace4e880793c592a62b372766672b5da54f5303a5c252213f"
    sha256 cellar: :any_skip_relocation, monterey:       "d03bbe56e6700b88bc9f7d2ffb645ce14195f104dfb3bfaa3bed3588bd67af4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d325dac127e93392312f4a8a765cd01f5a7cfa31ac393e8fadfb8b68208d1a4"
    sha256 cellar: :any_skip_relocation, catalina:       "2e9b7418c6896b4adb3bc3f38d6d9884dc2c48dc1570a3c28f5339a62b094bc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7d79b7999699bf03a08e0ba35efeb5bb712c78c2543ca88f8a61a539e337cee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96a83da4a02e7c018ce5f87968d5d786ddecd6c6f1e1f44a38f5df7c1e12d574"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go-bindata", "-pkg", "wski18n", "-o",
                          "wski18n/i18n_resources.go", "wski18n/resources"

    system "go", "build", *std_go_args

    generate_completions_from_executable(bin/"wsk", "sdk", "install", "bashauto", "--stdout",
                                         shells: [:bash], shell_parameter_format: :none)
  end

  test do
    system bin/"wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
