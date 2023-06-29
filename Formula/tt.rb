class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.1.2/tt-1.1.2-complete.tar.gz"
  sha256 "b9425b2b44bde086e9ab54f2f901229d754da6c94167526b3344a0308865ab91"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "484298be5bf51d3ef1313b53d32231e76a322c2a9676b873aaebda97c50bc987"
    sha256 cellar: :any,                 arm64_monterey: "585f8c0d1204a9bffc66f317c62c8bc5b19614c27c1b390f0dd08515d4c74b85"
    sha256 cellar: :any,                 arm64_big_sur:  "617c176357d6934415b94fddf4140ca317df17af0fe1061780b5adc5380cace7"
    sha256                               ventura:        "43be17d8d348adb5ef5c5d0e07bb0248b23bf3bd4e19de3a5d930e0768b00fd7"
    sha256                               monterey:       "11b55b370bf0e038c3782892b534403025af111f4a8e0c68c55d1f111939599f"
    sha256                               big_sur:        "0ab7e33413c56dcc6b9c6d5ceda2479eb72778675cbfe246a769a0ff4baa3771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6e1d8e6fbe6efcbd0d830d8ff9aaa25438ee06a8da84a18bf51659882b436e"
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
