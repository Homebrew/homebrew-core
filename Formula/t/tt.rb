class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.11.0/tt-2.11.0-complete.tar.gz"
  sha256 "a9c1b05d547f622d329e791f710157ba8b889337a26ed2215ff862156bea9c4d"
  license "BSD-2-Clause"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c0e7f414a73d8a1f47ba8393f14ebb98b1ba7dafbd595c1913dca056b97bd3c"
    sha256 cellar: :any,                 arm64_sequoia: "6ab63d8e56f2df245cbe854bb9eb3206196edd57f2c4682be19787939b70c5eb"
    sha256 cellar: :any,                 arm64_sonoma:  "56a68cea046497844c9764d60fb95c9a853b94b221f0a1081519d3fb9e465ae1"
    sha256 cellar: :any,                 arm64_ventura: "cc0823f89f35c41d56f9bbf9201be2393b09672de59f813f81105efdacdbc48b"
    sha256 cellar: :any,                 sonoma:        "a203c9faf7c44b99380f428598f44aa9a57c8b5d87bec2d8736d4937b4ddcedb"
    sha256 cellar: :any,                 ventura:       "47eeb659c3ae04d58acef7618b1144c8abd7958c7d8b5a955782224969320e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "448c01c6d3bf5a331c99e1b50a870b33abfb695295bb6567384543d5557d47df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582f189afc1e1a27feeb14875f53b9732ed5a2edf5218513431d1b098f5bd34d"
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
