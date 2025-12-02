class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.12.0/wp-cli-2.12.0.phar"
  sha256 "ce34ddd838f7351d6759068d09793f26755463b4a4610a5a5c0a97b68220d85c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55c3a86b500e2a5c96b7ab4a7c67c6099c379a4b3e8c8ac4ca908cb33a65cf45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087f15d5afa17ba4483aec086b2945d0dcd477a55987775862fcabe5902ce8ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "087f15d5afa17ba4483aec086b2945d0dcd477a55987775862fcabe5902ce8ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "087f15d5afa17ba4483aec086b2945d0dcd477a55987775862fcabe5902ce8ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe158bfc51b92aeac10cb0d009dd3c44a1e8c1cb0ae60ea9cf9a1b67869e7fa8"
    sha256 cellar: :any_skip_relocation, ventura:       "fe158bfc51b92aeac10cb0d009dd3c44a1e8c1cb0ae60ea9cf9a1b67869e7fa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1e3cfab199c3600caad543c0f2ea97c676536b37aa0eba544ab34434755f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1e3cfab199c3600caad543c0f2ea97c676536b37aa0eba544ab34434755f7d"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wp --version")

    # workaround to fix memory exhaustion error
    # see https://make.wordpress.org/cli/handbook/guides/common-issues/#php-fatal-error-allowed-memory-size-of-999999-bytes-exhausted-tried-to-allocate-99-bytes
    output = shell_output("php -d memory_limit=512M #{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
