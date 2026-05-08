class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.4.1.tar.gz"
  sha256 "1f06e1da1bc0bbd85170f8876a488d60eee7b5fc05b5e4f9f2ce0ef6f54b150b"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fe45e4ea559def7bc362301135169a55121d04175a530d3991d02139b00e6ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5330075f63214a27bd91dbb0fc6e45fe9fd44d2dcf193095b1f6c0edc72a0502"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00691151cc50d64c1347f5fd8e3634088c2a9485de20a0230a1d86ce801209b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f882a7c747cdc2a62cb881359a4340aad865125765763b21be52c368699ef92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dc2f5b55ed885edd11ac57ee1dffaae115710ff796b0c1d721d1c09f786c311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b56497fdd294634361ed6dde64083d8e9d727cf7536a2b803b2a4b8f9f65e6"
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
