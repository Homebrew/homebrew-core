class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.54.0.tar.gz"
  sha256 "680154d5090cca347af2e89555e2ca7ea23f261c0b787992ca465dcdae06b876"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7061296fd7ae825b8d1bc2cdd6f5aa7408058625ad8b9a3fae6aa9eeb10de38f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e475794aaf7117e37067f4a2545a1b1f3746c37f9f31d2cb8ff702df7e2f7001"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f66f3a1a0e413fc11d44a5b182f971d4585ff5bd488cc05ac6d98dd31947fe73"
    sha256 cellar: :any_skip_relocation, sonoma:        "39d50d4db43ae09fed8fad9854fd345c1c23474c5c56ba51ffe4ee58c031f63f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b03077fcb6e6b9177a95d259d68f66643acacbe86e7e263dadedf4a7c9e13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "704ef06bd2e9b240818a8118d2a9efeb6cac0b7dec62de2b533fae94d87df3f7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "openssl@3"
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
