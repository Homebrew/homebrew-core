class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.44.0.tar.gz"
  sha256 "c671816898cde99ddbb9d09a47681b98d26f8adbe5cec63695edadcef4cd6b65"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "341ef69b584b9bc77c50e668792ba3455a40856c427a7f7e137caa66b59f5230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83fe8b6d7f50cb3a67c2ebb8011afd2794206f8a5a91e519c0648d95bad0487e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e78000396606f226f6c5ca7e5373261120cedc0feca3050ba4786b4abdcc3339"
    sha256 cellar: :any_skip_relocation, sonoma:        "b38015f0681213a4ecbb0cea2d917a7b8595dc3561fe07aaa903a174d53dc069"
    sha256 cellar: :any_skip_relocation, ventura:       "a23b35f4dc5c6af6ecbcecccab576885220b69e23065c73f00bf4b270f49b9fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6c86bf38c9b646865ccaaaa368c02dbffc70c92e1dbeca814bf2c94fa664ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5ce3f6c9b38abe32707af36fb492e8f9359ee65ff3a274892bc99b738dbeea4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
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
