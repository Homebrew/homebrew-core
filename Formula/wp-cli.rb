class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.8.1/wp-cli-2.8.1.phar"
  sha256 "8503cd579480d0cb237b4bef35e0c3da11c2ab872a1bc8f26d2da0ca0729b6a7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d055f416e423ac9b78efa2653133b7e33690e10b2c29334936caeca9f506338f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d055f416e423ac9b78efa2653133b7e33690e10b2c29334936caeca9f506338f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d055f416e423ac9b78efa2653133b7e33690e10b2c29334936caeca9f506338f"
    sha256 cellar: :any_skip_relocation, ventura:        "8ba705dc04e55af5fa8d33d5b450fd9e390203afc42b7280b19223cd5a9633bc"
    sha256 cellar: :any_skip_relocation, monterey:       "8ba705dc04e55af5fa8d33d5b450fd9e390203afc42b7280b19223cd5a9633bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ba705dc04e55af5fa8d33d5b450fd9e390203afc42b7280b19223cd5a9633bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d055f416e423ac9b78efa2653133b7e33690e10b2c29334936caeca9f506338f"
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
