class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.43.0.tar.gz"
  sha256 "940917cf27a79297e0e682c4c3b1475fd8b112faeb0a33cd5a1a74086ee5eb8c"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "022c91ca0ffec9c7a7fdf2efe5e87ca50f1c82e8da0f27a4409f1f855689fa5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8fdbcd902cc447796ed96cedbad00e9a8a71d3d054ba43db4af55e823976015"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22452de64d02704083e3cde979ad240ed552463afded23381d6f44e93de9869f"
    sha256 cellar: :any_skip_relocation, sonoma:        "37337679437529a1cbcb0dfd7823f92afdc1221b99e764c182f8423b52ac2454"
    sha256 cellar: :any_skip_relocation, ventura:       "f6cc231336f46a6eaaaffee0c135f3dc0328d4604885f25602f47d08b66b53df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56ecec9beaefddc115c29c2824625c24f0161f1382b88c22e1fe7deab8d238ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893250cdd4f63963dbc066c3109c38afdb2495d569629a1f4d2e688e20430d1a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
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
