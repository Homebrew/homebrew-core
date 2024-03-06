class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.2.0/tt-2.2.0-complete.tar.gz"
  sha256 "da989f49268da1cf70bf6e7617ffb6743c05f67fa82b90fbb0b4e7a8f0f70aef"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "846eb23fbb4298d49f9059492309d74c9c353793d1a4a0210fd083988020b052"
    sha256 cellar: :any,                 arm64_ventura:  "e395b546bc6fa0ea02a7518b709ce747bd825729cc0165b71b9e5856980e064b"
    sha256 cellar: :any,                 arm64_monterey: "8922950cd37f03a578ad1caa07dd8e6fb852c31bfd2aea04655aade044f01309"
    sha256                               sonoma:         "9bc1ff032b913b0387bc0e8903799f6368f2363473d88ed63d768778818fcb35"
    sha256                               ventura:        "f18aca23a1ef3bf5f4141957e97a5e1b0acc0470b96ed6a4a0e772da92b654e0"
    sha256                               monterey:       "7bcfd2f0a52a98cefaf833d3cec33a36123e90ebdd8eecebd8bb0dabc05bd74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9804ab48ebb2796c3d5f0da3c8e3d0cf3ee2201833dc5ee97fecff007778364a"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on "bash-completion"
  end

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "package/tt.yaml.default" => "tt.yaml"

    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
