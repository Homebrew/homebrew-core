class WpCli < Formula
  desc "Command-line interface for WordPress"
  homepage "https://wp-cli.org/"
  url "https://github.com/wp-cli/wp-cli/releases/download/v2.11.0/wp-cli-2.11.0.phar"
  sha256 "a39021ac809530ea607580dbf93afbc46ba02f86b6cffd03de4b126ca53079f6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "128bbeaf8252ce48f6d5f4f37eada79478f33285ef5b216255f0a0ac70a8d2b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b60f676144decf7f7a7357f97029fe40cb946e6a9a470794f5610a14964b0c49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b60f676144decf7f7a7357f97029fe40cb946e6a9a470794f5610a14964b0c49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b60f676144decf7f7a7357f97029fe40cb946e6a9a470794f5610a14964b0c49"
    sha256 cellar: :any_skip_relocation, sonoma:         "17ab14f199e16148b4efd4e2704650e450513ff99e724f36a485761cf722eb58"
    sha256 cellar: :any_skip_relocation, ventura:        "17ab14f199e16148b4efd4e2704650e450513ff99e724f36a485761cf722eb58"
    sha256 cellar: :any_skip_relocation, monterey:       "17ab14f199e16148b4efd4e2704650e450513ff99e724f36a485761cf722eb58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa9280acd31b4b1b7f7d567d1dfbabda11d2bc0cc25fc34f49af131bf613c0f"
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
