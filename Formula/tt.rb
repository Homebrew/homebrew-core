class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.0.2/tt-1.0.2-complete.tar.gz"
  sha256 "e4afa215b89e9c69385caaac71068523bf4024de5c59a6c89a0ffa8eea482cb7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bf8bf08a3255043a8c7c9511f82e96352cb01fb818614e6ab33f6609785ec1b7"
    sha256 cellar: :any,                 arm64_monterey: "9750e395a9bd5b1ccf709fb8e3d25a6290fb8bea43edc188b2553aa989f70985"
    sha256 cellar: :any,                 arm64_big_sur:  "7d63b4b7a9e2b508ac86b25837ad5b16c0cf8132b9fbfea9d34e6803ee344ce1"
    sha256                               ventura:        "c14540aac29d5ac416ca89f34200c3c76bcb07e3ef3e36dfe2776f23b3faed7a"
    sha256                               monterey:       "97cf24927043de0399a89ce64f04d328b2a78b62d35da09d235c798e3697dc24"
    sha256                               big_sur:        "c5818d0fdf23bb86e2e58ae8b3c8b476c2be653806a16cb2a5ec5be87de095c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216f33529ce8882567402ef646fa1ec3fb2bee39d65f121a056a9f81f2ec017a"
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
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
