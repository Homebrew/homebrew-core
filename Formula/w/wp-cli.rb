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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acb797300bd0e5ebe085dafe27f9555653ee3eaaf41b964223352cc39a389f71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ffb49dd4e4f31aba979ab2619d095fcea87ed9881a9aa59584c753a41ef4e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ffb49dd4e4f31aba979ab2619d095fcea87ed9881a9aa59584c753a41ef4e67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ffb49dd4e4f31aba979ab2619d095fcea87ed9881a9aa59584c753a41ef4e67"
    sha256 cellar: :any_skip_relocation, sonoma:         "928bd3cb32c6aa7a2e429c076986ff324fee6cc113b946efe3c1f62794924004"
    sha256 cellar: :any_skip_relocation, ventura:        "6f48c52ef73dde3146221da2c72a83137efcdf1a35c737fd043bf9718109d1bc"
    sha256 cellar: :any_skip_relocation, monterey:       "6f48c52ef73dde3146221da2c72a83137efcdf1a35c737fd043bf9718109d1bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f48c52ef73dde3146221da2c72a83137efcdf1a35c737fd043bf9718109d1bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ffb49dd4e4f31aba979ab2619d095fcea87ed9881a9aa59584c753a41ef4e67"
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
