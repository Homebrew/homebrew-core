class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.41.0.tar.gz"
  sha256 "40a34a2c383bf06019eed238c1e97b2e5d449dacf0cef893346f68d928e7fa88"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e2cf13acc8f82b6e9b600ca09746a95bc2d1de86cabb9fb319e515f9918fbb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df206b7c91d270218cdd3ad883ad77f370281625c80836cb55a4d3df16efce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29324283066a99833d26861931444cd4e3f00b729d6646d6d9ebb3573761e11e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5da8b0c39c2fc51f7efa2237dca63e64dc2dfb99d220c0948525abea22047965"
    sha256 cellar: :any_skip_relocation, ventura:       "1e7fb8694f914e524258c42dfbba54167a1b982f92234a900bb1384bedc808bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86ce8f0a8aec5ba60d3721157d47a207bfc4ede9bdb3689024c814fdef936ffc"
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
