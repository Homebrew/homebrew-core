class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.50.1.tar.gz"
  sha256 "1f08454212cda3bfd71a51c06371c9c8b2a09aa862b553fa94ed0ca8d840ed9c"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e48ef6e8ca81e7683e61d9d029b7caebce9cc783b0dd6acf957f235649cdf9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99ede3e32ce4e88eebcfb7fdc814dea22975c95d79525d55eacb54792719d503"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43e97f9d8d24ba77f0902d69954e00e34a455cb030694090959ffbb5e91d88cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d194be2f390878195c1fc5b54f2352bd8f3314d19f468e10d64ce8fcb7ef57d1"
    sha256 cellar: :any_skip_relocation, ventura:       "8b43aff552a77759d96fb006e4a09f5c1c7a38e6cace263572323dddfba40eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07df704b1b74e24680472336f9d19b9b350de508c69d19fd449913b91d58b8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "479adb0beea1e8a302099bbf84de1f138ebac79ec3388d49d8d527870dd1600b"
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
