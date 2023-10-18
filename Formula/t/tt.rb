class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.3.0/tt-1.3.0-complete.tar.gz"
  sha256 "e6409a76d32698120b96fb9b13cbd3d73b9aa7d22fe5fbd88791cbfd62b0758a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da143297f9033af7f29dd69e8afc517abbd5661466249d0642549fbcb629777c"
    sha256 cellar: :any,                 arm64_ventura:  "002d58e37e703f5bb61d55e93c803b8eaeec5873fd99e0d08c0c1ba158f7f281"
    sha256 cellar: :any,                 arm64_monterey: "0f50f04f4d14c6ffbb9a3b1a1a5b32bedb44eb5782c08a1105492dde013764b8"
    sha256                               sonoma:         "2d343f1ce7e591415fb6dd4ee45b1555df1d73e6c42e18b0cd89d859fbcd44b2"
    sha256                               ventura:        "792bd7e3290b3b0bd08a289f4b71648d6fed26d33a836f01caebecfbdefa9e1d"
    sha256                               monterey:       "1f851ea0a2601c2beca37f5b2baf1c83282dc1d3d2a3a882b8923654ada8aadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d32f432f4053d9688bdc2f148fedd2dfa6522215e9eb87acd1a2338af17e4e3"
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
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
