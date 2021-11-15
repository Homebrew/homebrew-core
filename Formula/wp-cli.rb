class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.5.0/wp-cli-2.5.0.phar"
  sha256 "be0853e9f443f3848566070871d344e8ad81eb1e15d15dcf9324b4a75e272789"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f99dcae45bc3a8f8ea09d534e1050201391afea5fcd42287a5d24aef303dcc4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f99dcae45bc3a8f8ea09d534e1050201391afea5fcd42287a5d24aef303dcc4"
    sha256 cellar: :any_skip_relocation, monterey:       "5f130b0733ba0765afdb46836875c83e848b5b6bf53990cdb4b1e2282cf03171"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f130b0733ba0765afdb46836875c83e848b5b6bf53990cdb4b1e2282cf03171"
    sha256 cellar: :any_skip_relocation, catalina:       "5f130b0733ba0765afdb46836875c83e848b5b6bf53990cdb4b1e2282cf03171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f99dcae45bc3a8f8ea09d534e1050201391afea5fcd42287a5d24aef303dcc4"
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
