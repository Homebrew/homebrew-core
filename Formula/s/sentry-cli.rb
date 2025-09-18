class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.53.0.tar.gz"
  sha256 "60a33ee2e64f49e51ae507cfc66e29ec49c2d8313b06a694c3e54342efa86eb6"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "244c859f5160bbec6585ae55f2c3eea1dcb751334560db39986b3def46b42535"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4448460181002dae8165c2a41b6764a650c8f316f9460ebd1dff449924f0c8d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30671a82d41d6ab36cb69beae15ce07939d8888e17708f477457664be444d7f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31db3b87c8bb57f8f69e4b99d713ba4882188e26a4bf991e45bc47abdedd1c6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73b8cc2b79d7f3e2f28d08b6b6bf6f166a75a83b5eca073cc2b0a76a9ff27cf"
    sha256 cellar: :any_skip_relocation, ventura:       "9904e1b180a0286bc071329f88e86b02ad9e75381440fd4f4c6c7d67b6089c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee212918e2cbd1066258f16ae51ed0698b4da5541c77716801204289a3b015cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba47d2b73863de5615a9f9fc4c7b367e41da41b2ec6972eb997c2cbc28dadb3f"
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
