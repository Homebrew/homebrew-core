class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.11.tar.gz"
  sha256 "89ab11ccc1477d3da6f831e1cdbe2330c6e4ad5188ff832cdffd79a9208c67e6"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf6b887520d01b000f5a52db9f1a71def1f147923781cb12c010d673b60730cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "178102646200ac336039ba32d52f94ffaea5c0feee20b64dfeaee82a770342af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c472358518aac67f839167b7560c7c1c7e969a8a60ae8ac0e07d77d17ba4b27"
    sha256 cellar: :any_skip_relocation, ventura:        "6189b8fbfa301cb4f2bd76df506778887a360859b90f84dae00b2f6721fbda06"
    sha256 cellar: :any_skip_relocation, monterey:       "d0101a48b56d6ddf19a6bc24349d535e7bb97ca9cd1096b44c7c3ad14d5bbf2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "90f4f24a69c3e1da19f9e38e1aaadbcd1829b463fa0afad6aaade4f292574cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e450190459a747d447971245e12e1488a5249d8b96c494ace40f043eacde0e20"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
