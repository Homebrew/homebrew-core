class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.2.1/tt-2.2.1-complete.tar.gz"
  sha256 "64a53e3484b86af68cd5fbca9b15f13068e70e23133d6b30f5c79440bfdf7f7a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e165dd4c456dcafd8e21a87fc397f2691ea54a5f8f81f4431a8eee228765cdec"
    sha256 cellar: :any,                 arm64_ventura:  "3cf7c8fed1e3e90645d52969976925a2c717b136bafb212f86f0f88cef26ac01"
    sha256 cellar: :any,                 arm64_monterey: "1faf32fd58c1ee96848e69de866e53201bd54ae0f56522034afe7f03ab9cf340"
    sha256                               sonoma:         "88ded4f39160df53fd2d404a2082cebb94f51253885e80400ff6e3aa23800bda"
    sha256                               ventura:        "1fbf8afce343860d07b8b6479afa5fe6c32f0b669cc1b595804c3e0601fcc4f3"
    sha256                               monterey:       "ec018819564ed6fcabc0fa05f2c506981d6f8e644f530135842c1de1e0a79821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472c7b3e21cfa47ca8ad115d8cc009dd541cb5c1718e158798ca4b4d6f835f91"
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
