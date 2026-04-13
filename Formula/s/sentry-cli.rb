class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.3.5.tar.gz"
  sha256 "9ec565db99e85a29ca5ada4605581fa3e8a93e8ac9509ef6a47dc4ca3a269044"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46a922f3ba8be8bc5452f8ce1b6910f17e8cc23915604d751fb6e332b9ba43eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d272e7a1697d739cb03b92556a962c58c13ac8b71e6ebf0958a98c02eb9abbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c902b6f6be5fdb805b5f47a9ed2b32ba2c3d9bdee8b597080588b59cc8b4de21"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c07e1c10453435ca9a425387211634713d3f1297b56948a9f195cd85f7f0fd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c48236ecbf784942cdd7e36296a6f7b466b818f1bba8ce797647e025ff6c08db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4892f7f41e4ba82d1eaecea8b2ec688ff94772e16b9f8ae776d502fa34ed6b5"
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
