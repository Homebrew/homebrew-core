class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.4.0.tar.gz"
  sha256 "280243cfa837661f0c3fff41e4a63c6768631073c9f6ce9982d9ed08e038788a"
  license "MIT"
  head "https://github.com/dduan/tre.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f787031ef204c5d4e4dd52c3dc5481060a511566ec3ef62e384a9db088f1cdf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfbf9c430e051dbdd5760442116b9f8ac7460303eb9d8a56b1c9e8cb43c0c1db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba30451c10d70726bb77ed8778270a6c49dae005705c414ed0393b12c32b0c02"
    sha256 cellar: :any_skip_relocation, ventura:        "977aceaa612ec136e51822d3b2a41104b8ad894c0df446978281de0ad33fd3fa"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc8517f7b935c90ef76f8e34d5848b94c8465748d1ef11482c3b2a7fd317fed"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0fa68cab885f6f6df3d68728f8ae1fd5a37d70193e446b0c8f323987f57842a"
    sha256 cellar: :any_skip_relocation, catalina:       "8b8e4a41a926e429fdb9aecc7838e5362e193b1054a7ea3e2e8622dac360e6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08bc7da0c42d6496d0cfdd537d6668ae0250df89f0c1bf0aee5f580c7455be88"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end
