class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.58.2.tar.gz"
  sha256 "f548e09d13f8bbaab9f65d552699c939c2d2674d8f119f857bcfb61e52f6f266"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b1d5d8938361b99d8b105a51f08f0f171f632590cc74a49349f0f3996ec9546"
    sha256 cellar: :any,                 arm64_sequoia: "3de210820a9b124556533cb8bcb86cecc555bbfbaa1bf0c35dd3013286c695c1"
    sha256 cellar: :any,                 arm64_sonoma:  "c24a71324ad55d8a72a303ae382220379bf85741c4d68aff0b4c7094baa43283"
    sha256 cellar: :any,                 sonoma:        "b787fe5bf1ef1b08b764b1d05588c5ed78a106d4ece3c604e5bc75e8553af231"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eacbf8ad2b8d6fbc8bcf025c5f8ee5f6af89510ba079eb33c4a2c03ed4b4f79e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8e06e1b72438954c0ef33734e98ad2b4fc118418259e460c2e9a497bf581df"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
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
