class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.14.0/tt-2.14.0-complete.tar.gz"
  sha256 "311bdbab08d98c946ae42f336fd033802a27bfe50bf8d8ca018ebaf7c333c500"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc605d2c008d0d23926cc54a2b115ee87181cfc98ca946076b5fcc85c3cc40af"
    sha256 cellar: :any, arm64_sequoia: "61bc13d81e0cbc96b2c7db81ef2ecbc5237572b7654c874dbe3822b4bb763ea1"
    sha256 cellar: :any, arm64_sonoma:  "628a3253ab986f63f9cee5dafc74b480da7a42ba6fadbdfc18f40eb4deb8bfc7"
    sha256 cellar: :any, sonoma:        "acb9e81beae084e1721d138f376154f8eef5216b4d39d11c9f833f6c9eb93ab2"
    sha256 cellar: :any, arm64_linux:   "d8ca30012ae2a98af1f956ac25d7ddb6f5d05f5cc6d1da00b0e6ac6c0b1e19f4"
    sha256 cellar: :any, x86_64_linux:  "b47ef62a574d6a8f8fb52495809aeefde8516b64f83b67e0a2cdac1063739e88"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkgconf" => :build
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

    generate_completions_from_executable(bin/"tt", "completion")
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
