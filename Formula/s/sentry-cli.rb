class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.5.0.tar.gz"
  sha256 "0c6407ce0141f9576341bf21be2c64367d591a31b70289dca30621fa76cf5a4e"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1a82420202bfa59da11289a6ed1c49e741dfc49f6fa0ec5896254052bc4fccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd7daeafb604c78ef9f55791eca9c2e3ec1d2a82ef0edf5e279a8e09220361f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580b04ffdea29aeee7cf07165a75c5672a0bd8d40b554f53f4f7e18d26b7c47e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a7cc1fd668c0095ab71c58cc4480586590065af6af8b1389919fb466d6d4677"
    sha256 cellar: :any,                 arm64_linux:   "85b6783aa3f27e8a1132adf7d5b1445e318f2fc74bcaeb2d0d777de3ff6fdc38"
    sha256 cellar: :any,                 x86_64_linux:  "63602681706c7f0f697158696e4f8e7510be50229af6503fc6b3a280b758f42e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end
