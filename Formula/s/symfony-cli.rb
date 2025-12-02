class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.16.1.tar.gz"
  sha256 "9222ea6c4996c1231577f7475c65902f2eb332ee5249d06c6017218dc35c6a19"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7294e9bb6c9b561d7d568a66a2594923da43f4d61577be9c14144f81c2dd4601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39d0aa5ab764b9db8ec29445313703267d2041d00607d8bba71492a6c2b93e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fdb7cbb13b2a54f94f05e2e5f684df055457ec031f3204be2af50bf42135f8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "61c748301831d07a267613df6dbfceda7a00812e199fd3acceab7da66d7aec52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3489c0d872fd805a1aaec5309e272ea9bbd7e39cb41ee0ef22decbee605eb48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c147525fbbb70028f6a75ccf68d2f8b972efa2c006d7fe6f595a14d9251ec359"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.channel=stable", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
    output = shell_output("#{bin}/symfony -V")
    assert_match version.to_s, output
    assert_match "stable", output
  end
end
