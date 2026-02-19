class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.2.0.tar.gz"
  sha256 "859caba03f1c022e7ba2e580a40219b77b2753f3f7dd5f472c7f8418c69a740b"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d604d425fc029883e78c240108ace528c73809030f5ce34d67e6d9dd378160c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b02f9f07d429f4f7c475d554d046ef80c59acf4a52462645c7784fc5063794c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8e53a72f6da7c2abee8f7b75f897ab0aa6477b65c89fc69b8dd315c5b211f30"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d5755aa7ab3c28633738feccd99c2b91682aee8a97e24e0c83ce223b00bc170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d000c38b10b8cc3f4da6e0a1678eb437d8ea82a3f6e8995b105867806d81375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be18dc78bc501690b1ded9a15ec0c44e5d37da1825044779457085bb66a53350"
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
