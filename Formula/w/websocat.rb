class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "ca6ab2bc71a9c641fbda7f15d4956f2e19ca32daba9b284d26587410944a3adb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6afb5db8bd6ffdb773033bb657e06dac1d7e43c6a7cac1b8afad6ebe292bcb5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc2139c707ac38b85de0cdfae80e2204f6148a65224306d62ae40354422c41bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c612057e9aab99c958b0b689b0bd61754bb93ff4d91220f63babd369f695afd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fba655feb506df9af3717809b4d849c1704f417de006ef5813ccecbcb9445a64"
    sha256 cellar: :any_skip_relocation, sonoma:         "74eabe62b89cf3b970ffa7b50f2cbe9253494ded0069e1faeafc673dbb8dd97b"
    sha256 cellar: :any_skip_relocation, ventura:        "d4aa53b9d6fc7b9fb0543982400a2c4200ddde314cb04e2ef66051d380c1f5b0"
    sha256 cellar: :any_skip_relocation, monterey:       "fda1056d37720a2b6dd9aa6eeea78556f0a76ac325cf90550cb43a10072829ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2783ed46e6bfe8714459775b7b8557fe69f572d503f115f120f307148a25e06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265ab8fc1cf2ab156b6fc458bf229824ab3aa184d251596dc5473a80c90d8ee2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
