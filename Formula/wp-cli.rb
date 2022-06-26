class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.6.0/wp-cli-2.6.0.phar"
  sha256 "d166528cab60bc8229c06729e7073838fbba68d6b2b574504cb0278835c87888"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee8ae5d8225ee58093857e74e69c4b148f23cf3c0c0c6c41c27f1b0b9b410121"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee8ae5d8225ee58093857e74e69c4b148f23cf3c0c0c6c41c27f1b0b9b410121"
    sha256 cellar: :any_skip_relocation, monterey:       "c02c370321bcf6458c96d5169b0752840b914f2224676aa32ce32cd416dcd280"
    sha256 cellar: :any_skip_relocation, big_sur:        "c02c370321bcf6458c96d5169b0752840b914f2224676aa32ce32cd416dcd280"
    sha256 cellar: :any_skip_relocation, catalina:       "c02c370321bcf6458c96d5169b0752840b914f2224676aa32ce32cd416dcd280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee8ae5d8225ee58093857e74e69c4b148f23cf3c0c0c6c41c27f1b0b9b410121"
  end

  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
