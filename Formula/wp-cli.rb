class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v1.5.0/wp-cli-1.5.0.phar"
  sha256 "f615d57957e66a09f57acc844a1fc5402e9fa581dcb387bbe1affc4d155baf9d"

  bottle :unneeded

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
