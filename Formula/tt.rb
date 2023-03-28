class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.0.0/tt-1.0.0-complete.tar.gz"
  sha256 "6f42d30b9d9f9fbad1907a49cf3394f71c2c86e3faa1194fd9372e4d8877c792"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "68443da882962159e076cca1f774c1f39879175275b1444bd0b03e1622ac6276"
    sha256 cellar: :any,                 arm64_monterey: "1a93634c292d269a4461cd4cf0921ac6676f873b457c198a86f4557fcda90027"
    sha256 cellar: :any,                 arm64_big_sur:  "ce286cb1068543c4f990984ee533c9ecae8d372f10194190aa94d8ee2dcf450e"
    sha256 cellar: :any,                 ventura:        "5414c4ed0979f8cfbe8a137ee0ddc824c1eaf22fd3b1aac8a26db9d04b2b1389"
    sha256 cellar: :any,                 monterey:       "0865f458cd00bbba2154bf838e6b9ac5bcd08dcb56d6ef02e817cc6ebf48f29c"
    sha256 cellar: :any,                 big_sur:        "2a371ea6f0c0682e1149a58f9ddcf16236912eba4b3c6c035e9bef9801cac128"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75158fb6327da02e4289b1aee6d048cecc1cce17609dacc5f13f8b60fa50802"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
  end

  test do
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
