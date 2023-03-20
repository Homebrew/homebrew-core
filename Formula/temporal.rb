class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "1a0b989dd1aaa86b2ff6681cf54dc677a7228963a3dac70c157b7857fbf2690f"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50807d42606faffb88ee901ceaf96bebff6da1a01140d6c7b992cdd918c356c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b147b14e06d74fae80ef7453d603a0fd3bc5860d114f65b45edc17b4319b93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b4f37e273f4eed46ff44e4916cf3b567ed266f89d9cab47d3f0fd9f50b72cb2"
    sha256 cellar: :any_skip_relocation, ventura:        "92c175b4f5cd48b209e3d4688ce2e40e1d6c43bff09b7d3eaf8fc77bea205a46"
    sha256 cellar: :any_skip_relocation, monterey:       "0868971241ea9b3ffd6d44e80d78510264824c525669a2976e500085ffb7dbf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfaee9f1e332c9110d21664b9837ff04fad20dbbfd26a94225ae5190c8d8dbeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7bd39f6c3c5d936bbdac3c9016ccc66b29e8949a862f9676a796398ffca47ba"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
