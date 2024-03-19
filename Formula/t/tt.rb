class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.2.0/tt-2.2.0-complete.tar.gz"
  sha256 "da989f49268da1cf70bf6e7617ffb6743c05f67fa82b90fbb0b4e7a8f0f70aef"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e4fc38e4386e529dfddb0dd51a0ce99a85c8c57f9737f88d87d20946455c9070"
    sha256 cellar: :any,                 arm64_ventura:  "4895166df988ae8057318b0b8eb72546ecd1014a6ce4f0242b1365d88472eac6"
    sha256 cellar: :any,                 arm64_monterey: "57a646397635bdae8012694da92c85402aa708fd17e39a866e28834d1f868270"
    sha256                               sonoma:         "66fd4ad2aaaf71f49d3333a1476b04a11ebb427ac7e9c12be5b8e908d1e6d3c3"
    sha256                               ventura:        "0106a68dc8f66d272b1b16ad37e3673725bc3939df96b77edbef90e6796263f5"
    sha256                               monterey:       "1f4db740066c7b6f698d98c7409494a1e81f5a12d16e1cfb1baabeb3a7276860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0388451c4d65b0b920a2c0d9906889e2eed136b8aadba7e899103027dee0f0ab"
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
