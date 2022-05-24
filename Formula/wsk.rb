class Wsk < Formula
  desc "OpenWhisk Command-Line Interface (CLI)"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-cli/archive/1.2.0.tar.gz"
  sha256 "cafc57b2f2e29f204c00842541691038abcc4e639dd78485f9c042c93335f286"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23767d9b5c73549c6c70b9abf373fe210eac47d313e4f0ea7a6788a2cfd0d077"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b2725953f3e57cc34a264d08038690152cdebead514185f2727eda86e339d0"
    sha256 cellar: :any_skip_relocation, monterey:       "271c0e8fbe27442924af44be9409d46dfa6b2fa6b907d1f93ba20c0e5a0cdf0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e84a614165531b5d1d4d6ec04eaaa1231c1b829b8c32e64c57ed670c8ccbee29"
    sha256 cellar: :any_skip_relocation, catalina:       "0018d1080479df041f52d6bb92388048cdb6539864f686b8fd92107626a33227"
    sha256 cellar: :any_skip_relocation, mojave:         "ef1a2d5b366f2d0fef71e5f9a56cf764c8aff282677046de639efe254d1fc9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7425098df98b8d73d3aa6f4d205fd0327c01a7f5e76fabe4cefe46a940f52deb"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "go-bindata", "-pkg", "wski18n", "-o",
                          "wski18n/i18n_resources.go", "wski18n/resources"

    system "go", "build", *std_go_args
  end

  test do
    system "#{bin}/wsk", "property", "set", "--apihost", "https://127.0.0.1"
  end
end
