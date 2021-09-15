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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ae62ac60656fe354a25fe4a143e58801a037ab76243218e6e2bc1eac4f5f1345"
    sha256 cellar: :any_skip_relocation, big_sur:       "67acd9816806eef402f59f1904fcebd2e23e6d6cb7657604430e299cf21bd300"
    sha256 cellar: :any_skip_relocation, catalina:      "67acd9816806eef402f59f1904fcebd2e23e6d6cb7657604430e299cf21bd300"
    sha256 cellar: :any_skip_relocation, mojave:        "67acd9816806eef402f59f1904fcebd2e23e6d6cb7657604430e299cf21bd300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3538f32afa8bef557e659322b49734e90e0420cd96561ea56119f71d91d813c"
  end

  uses_from_macos "php"

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
