class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.7.1/wp-cli-2.7.1.phar"
  sha256 "bbf096bccc6b1f3f1437e75e3254f0dcda879e924bbea403dff3cfb251d4e468"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7868eabba4f5f380a94488c1f136d9945ee152836a4a44456cd8ab24add74c98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7868eabba4f5f380a94488c1f136d9945ee152836a4a44456cd8ab24add74c98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7868eabba4f5f380a94488c1f136d9945ee152836a4a44456cd8ab24add74c98"
    sha256 cellar: :any_skip_relocation, ventura:        "6be0dde0e3a8e8d64b7cb81a373b91938ab054cc22a107ecf8149251cd7f40ab"
    sha256 cellar: :any_skip_relocation, monterey:       "6be0dde0e3a8e8d64b7cb81a373b91938ab054cc22a107ecf8149251cd7f40ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "6be0dde0e3a8e8d64b7cb81a373b91938ab054cc22a107ecf8149251cd7f40ab"
    sha256 cellar: :any_skip_relocation, catalina:       "6be0dde0e3a8e8d64b7cb81a373b91938ab054cc22a107ecf8149251cd7f40ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7868eabba4f5f380a94488c1f136d9945ee152836a4a44456cd8ab24add74c98"
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
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
