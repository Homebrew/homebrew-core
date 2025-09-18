class Skeema < Formula
  desc "Declarative pure-SQL schema management for MySQL and MariaDB"
  homepage "https://www.skeema.io/"
  url "https://github.com/skeema/skeema/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "05e526ae3b22ba3baaac69b7170a1095a18cf3c4b0600fe7691e0d5bc6476b44"
  license "Apache-2.0"
  head "https://github.com/skeema/skeema.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b4d3ad25616f19de0f4e6247209c2e9de4a3b141e635a54ea73433258913200"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f69347b2966e25b60471a4d1ea58ed252ecbe6a3e786bf933defe59fe0bd6bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f69347b2966e25b60471a4d1ea58ed252ecbe6a3e786bf933defe59fe0bd6bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f69347b2966e25b60471a4d1ea58ed252ecbe6a3e786bf933defe59fe0bd6bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cd1d16410a84b309e2e9981854d1cdbce275ee6360821d83aeaec751d5c618d"
    sha256 cellar: :any_skip_relocation, ventura:       "8cd1d16410a84b309e2e9981854d1cdbce275ee6360821d83aeaec751d5c618d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ac816cf45e24d02865b9d34cc0ec3ed700d8a5ae99321a8fa7494833901508"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Option --host must be supplied on the command-line",
      shell_output("#{bin}/skeema init 2>&1", 78)

    assert_match "Unable to connect to localhost",
      shell_output("#{bin}/skeema init -h localhost -u root --password=test 2>&1", 2)

    assert_match version.to_s, shell_output("#{bin}/skeema --version")
  end
end
