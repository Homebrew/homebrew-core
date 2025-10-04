class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.56.0.tar.gz"
  sha256 "2e9ca2e51b240363468142308f3596b181d7136c7fd5cf8cb8fa9947ae1c03f1"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbeab6947a99338a24db2043c2b49dd9748551c8e997b2089312aea7330e582a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a379c46e511d47261283576441d4c8da00f72ceb7e3566d9aab853a40d4453d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ca104f84e6967edeece35adefa9a6dd297bab586d8267c300e0fe5312be3706"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e02ff7232fb201cca88cc0eaab43d37c8a225c322f5bc8e810f85997faa3912"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a02a9e09d0cfa5fcaf416cb0c5d200961ca0ec02b2a6e5ad1a86a68b46e6a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc17e8f97985ee977de6cbce17f34cd0f486e702162c3473a0acbb98408fc64b"
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
