class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.4.0.tar.gz"
  sha256 "682600c6113b785261afe8cfdfe836068dc6f92adeecf1818248a989a5d849c6"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2af4c72eb52abaec17f96538b202eb21c79dd0af094333c14a53f721956b0e27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d306479255569da484a9b230c9318af7e4ee93874068bf20947f8afa1f7fa71f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8885cd8348d2cb6d1747285e6493a96d1d0d70021b52152fe8f116370ac21da"
    sha256 cellar: :any_skip_relocation, sonoma:        "eee81482a95cf0f872d71223eb13d11d8d9714c90620e0c202e399e465c06948"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "566d0da355f631ef42896f03a787f0ec44694ea7550946f54434e99e16367622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2faaeb9638c5692e882b7762221d79a79c8b1e6409c861f031c651e121a542"
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
