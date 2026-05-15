class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.4.2.tar.gz"
  sha256 "41140ef0f9b1a70136cade0af6d0798a1f662c44a9c903f86e20ee172c68e131"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca46dd0dfde4ffe0bce6e3fe432bce18f9556fc481416f40153636a3985c13ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a2328ef54a377853d8d00546a27fffc5ea7148309f3b73e3f9e443f507a0996"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87f2af5f3ceb414aa8a02237fe4b27f295b5f1ed46b9fe2b5a08c7c9ab3e5dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "95bebd0b15f2045b69b2d3167a53cb396a9301b4ea587dcb7e8b0e9cfec0299e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c161f7149d9515ef4de9ad973bcab258bd30b2d7d3b3c6d02e789b14277afd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d17a50eb2d31e480f64aee863d38d9b32aa3eac724566a6fc781571670eff20"
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
