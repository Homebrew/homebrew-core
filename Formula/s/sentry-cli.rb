class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://github.com/getsentry/sentry-cli/archive/refs/tags/2.41.1.tar.gz"
  sha256 "489f551c368c7ba061bba93b5e478184aef92a8a5cce2010607affb648a04bd7"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c37f4559d861bd604855dab0cbcc507fd94f30bcb911670c30c40d53b88a605"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d21f8baa7d2352f237bd13ed37b8f3c1b9e5ce8dfe34e1998dc62619a272ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff02c0a3603a5e0870a6df96d3770bc6000f52eb095c7cd4ddd8d6d7a1f60c0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "50dd18761b06156e83e9987d5fa92e2db4c529cc25a6739c85f38a3e0e21b9d6"
    sha256 cellar: :any_skip_relocation, ventura:       "12ad55549c8d5734f7faab37e3080e2b59a79483ed1f047061f6dba0df517cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9f19b94f43c5aa9a1235ad59a97ec60769a939ffa874ce9cf15d7e880d9fb6"
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
