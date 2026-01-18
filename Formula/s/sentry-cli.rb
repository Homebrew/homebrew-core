class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/3.1.0.tar.gz"
  sha256 "88b2c1f14cc2cecc8cc5c4c58e89113c4b2ff625e1c4231b428f8593670eca32"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7ad10fc32c95283dd226148da493e8ed52acf5ca5cafc07193ed18682d780da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936b01da30a6926ed523e1f0b754381ffb242449d20d43f2a210a3526915386a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d03ac174bc29a75e22358bc4e48179c1d00e68ae95186010e608750d0f24d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0b0b7598d6b2c7061c3f9da32b7a52696802917debaefd411a721a1b12ecb66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77afef5399584ee011e24bfff606da4fad20a38656ef6d404d61f212a26b5fe7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bcc9cb5b18bda1fd8669159afbe2cd85cc812caff179a8d2f55374a95cbbd33"
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
