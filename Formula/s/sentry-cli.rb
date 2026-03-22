class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.3.3.tar.gz"
  sha256 "8fe1cf908949d525d14b2ae0f5b26ec114fc2b7f5c0fbfa8367a63a7daa37e5d"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68dbf138e33e6bcac8897d27c09e3c96756346310f5fc54cbbfe324b62f8feec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9951f2d154d1ea23f78d53873efcb533fcdc367534c2d4fd44cf1359854e61f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a066359fbb5707c7c856131f8e67a32b8b768879432e25f176c98140936c26c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b5397cbcc96ba0615f7f4fc733728e229274d1b996323882c7204f7e92daf14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "453934f21a967ac4b53508a19b51629aad8ca75b7b70afa21a54883952e9b39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38f39ba4673b99bc676c3eb42104aa3cb0dcd979edea096b79d46f4942ac06d9"
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
