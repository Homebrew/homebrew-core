class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v1.5.1/wp-cli-1.5.1.phar"
  sha256 "0cc7a95e68a2ef02fc423614806c29a8e76e4ac8c9b3e67d6673635d6eaea871"

  bottle :unneeded

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
