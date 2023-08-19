class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.2.0.tar.gz"
  sha256 "cafc57b2f2e29f204c00842541691038abcc4e639dd78485f9c042c93335f286"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3289f914e422c1ada3312a27103e11a726b22ad5e1a473171f8aa4abe798be04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1e31bfc35f96c00b8baad80a700475f277a1882d7cf888708eaab2f2cf01651"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "935d6a0ac05fc9c2eba6252a8d229bfcfacc45a0ced4350adf6012f1028228ca"
    sha256 cellar: :any_skip_relocation, ventura:        "67d3ff596d0ca68ace4e880793c592a62b372766672b5da54f5303a5c252213f"
    sha256 cellar: :any_skip_relocation, monterey:       "d03bbe56e6700b88bc9f7d2ffb645ce14195f104dfb3bfaa3bed3588bd67af4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d325dac127e93392312f4a8a765cd01f5a7cfa31ac393e8fadfb8b68208d1a4"
    sha256 cellar: :any_skip_relocation, catalina:       "2e9b7418c6896b4adb3bc3f38d6d9884dc2c48dc1570a3c28f5339a62b094bc5"
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
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
