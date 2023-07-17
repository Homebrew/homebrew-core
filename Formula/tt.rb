class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.1.2/tt-1.1.2-complete.tar.gz"
  sha256 "b9425b2b44bde086e9ab54f2f901229d754da6c94167526b3344a0308865ab91"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "790695603d18f8a01502d965126d3781fa5774ccf865b5a38244cda746f82972"
    sha256 cellar: :any,                 arm64_monterey: "3d20599ee5caf0417f756b800982b2aca6792f51683315939dbb8ec0da1e5987"
    sha256 cellar: :any,                 arm64_big_sur:  "324ab76b91578f6df52cf79f8e09c7da47fe6f936cb24c17841d5d42fb1bda10"
    sha256                               ventura:        "7eee737bef94e4b0586a2ce52ae992bcacc2b9fbee894f546b628c76ce4684c5"
    sha256                               monterey:       "ca9121d8d02da7ca9276185b7b25b13a38c8b7337eeec5ff00ddd54dabc7dbe4"
    sha256                               big_sur:        "44d735c47bd10d9dd62699091fa10b9d7050dc8b5d5932d290ad2b5f968eb45b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b6a5f05563457a982c8dcf1addde2f06b455cf9db75dbde48131daa5d68f0bc"
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
