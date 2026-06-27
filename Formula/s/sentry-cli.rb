class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.6.0.tar.gz"
  sha256 "c3510864bcb5978ace21f2f4e4770738df4c34fe46b194ddf04f23aab0956faf"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85980cd84a774805daa1255b79dd1e9d8bc67579a594bef3dba677f6c07f35c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37716b194f9911919c85b2f8abf2218dcd9a60904d3dafe0354890a32ecdfbb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5074533988866738983ed218d9fba10122dc4247c5f36c9b920e30268a64f749"
    sha256 cellar: :any_skip_relocation, sonoma:        "68962dfebf3ad47cfa781321a57ef71c3f5faa74a104c9e80de41ec463456f71"
    sha256 cellar: :any,                 arm64_linux:   "0f5d1829cfe385f296168f606169b795d53c034882962275d3e5ed6023b2cb47"
    sha256 cellar: :any,                 x86_64_linux:  "f3320652e82130916ebca42aea424e653d925176053b0d48debe5bf574d039ec"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "swift" => :build, since: :sonoma
  uses_from_macos "bzip2"

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
