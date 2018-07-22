class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  # Checksum mismatch for 1.5.1 https://github.com/wp-cli/wp-cli/releases/download/v1.5.1/wp-cli-1.5.1.phar
  # See https://github.com/Homebrew/homebrew-core/pull/28579
  url "https://dl.bintray.com/homebrew/mirror/wp-cli-1.5.1.phar"
  sha256 "c1114450e647ca0c72afcbb6d02b577a55ec9915a510399579626c960d5dd2d2"

  bottle :unneeded

  def install
    bin.install "wp-cli-#{version}.phar" => "wp"
  end

  test do
    output = shell_output("#{bin}/wp core download --path=wptest")
    assert_match "Success: WordPress downloaded.", output
  end
end
