class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.0.0/wp-cli-2.0.0.phar"
  sha256 "577ff95cd9597389346872999bedb956b0fe034d8575cdaf9d3c72d936da17e9"

  bottle :unneeded

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
