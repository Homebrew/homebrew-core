class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "9d09197c3ea5e8c2c6709a342103d38db4528f80c5a635f255a19fc60956deca"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fd3851d94e83fa283abf3061039ee9403fc094536b2a9e391481a07c210cc72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4a8f95e4ab00ed49710307b23704a185888258114f4997c1a6f3125a806e1af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e686d9e15817260943490632a59a0f5c99a31732083fc36347a2147cd45c072"
    sha256 cellar: :any_skip_relocation, sonoma:        "71607cd88c818bc35a5579f4bdd19aca4683d9eb67a68779b97352c0015877d3"
    sha256 cellar: :any_skip_relocation, ventura:       "4a548b6092ac86df018450bf099346eddc96a54e366c55ed00e7085f9b160321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe4af37042b7931672dbee6065ea6d1e3faa9a1c598b777310e9fdeeb2dac994"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
