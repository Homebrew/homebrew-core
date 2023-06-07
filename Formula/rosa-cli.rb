class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.22.tar.gz"
  sha256 "fa628316f5ccd6073e8e85fc31d2427304d41d24105d5d053af67c72bd558ec8"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef43dd7cc342b1d8724f25d7425125527aafff7ed929de9b47d9755d17b7ba31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef43dd7cc342b1d8724f25d7425125527aafff7ed929de9b47d9755d17b7ba31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef43dd7cc342b1d8724f25d7425125527aafff7ed929de9b47d9755d17b7ba31"
    sha256 cellar: :any_skip_relocation, ventura:        "8d0d4a42adea79b3fdcf21dee911f3792d4d154e2e274a5b6453b9528f8a1913"
    sha256 cellar: :any_skip_relocation, monterey:       "8d0d4a42adea79b3fdcf21dee911f3792d4d154e2e274a5b6453b9528f8a1913"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d0d4a42adea79b3fdcf21dee911f3792d4d154e2e274a5b6453b9528f8a1913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81efcc03d4111afe1481e4603593d17a74a377401504f2a9e7779efad83e4e19"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Failed to create AWS client: Failed to find credentials.",
                 shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
