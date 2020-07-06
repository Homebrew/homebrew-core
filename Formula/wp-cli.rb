class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.4.0/wp-cli-2.4.0.phar"
  sha256 "139dcc86ed39ef751679efbdaf57a53528f1afda972c4e3622667cc27397b540"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
