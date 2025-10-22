class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.57.0.tar.gz"
  sha256 "7bf2adcaf9b808dbdab209d2115bad13f3c29cd1d4a1fa3427059a76d4d61618"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1f30ac4418807d43a4881ce2adf218ce73f1cb4fef304582033f2c3d5feb8eb"
    sha256 cellar: :any,                 arm64_sequoia: "66ad13cd98587da41c4d2b1f56de5c16089565e47586fe12f66aaeefbb411188"
    sha256 cellar: :any,                 arm64_sonoma:  "dfb0504cfb3a6f487174883dee56e3b27ad57327fe65f2be6988a9479fcc1c58"
    sha256 cellar: :any,                 sonoma:        "9696629965412be92f491fdf83dc28f73ab90b4162cb7b0be437149e87432dbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3066dbe60d2be3e516561299d81848da2057a058194843a0d70e2107560d21e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8980490a91be31edb750dcf85eea1125fc16eccffe5a7e7a19d0950e2b18c376"
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
