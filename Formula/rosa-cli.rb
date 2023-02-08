class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.14.tar.gz"
  sha256 "cef00794201d1a4b2a78cf4eb41a7c1b01f786471951010739dad440f214c216"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c119899cfd83dfeb9ea6fd31c781e99737b27318220637cae755e6a0a0842b95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8253a5192fb0e8fe60041d654d4fe76c228be5dbd03a33322d88a955dec69e2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "863ce9b48346360f4876e933d9501ecc0f1f1d19bf471c92774dfad29a62f14f"
    sha256 cellar: :any_skip_relocation, ventura:        "6ecc936e9d20234231b11b1a2ece6948219a1635bc9d4053797608d75471fb16"
    sha256 cellar: :any_skip_relocation, monterey:       "d44eaec43ee83c1d59732b7a6291e90083fdeca4005ca4decd2522e2c48ba300"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3f3c87b49121f74188e1d667add8ea14cb728483bb8a1a8c882e862760779bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a517ee91e9bf449b1aaf4e1d4b4d8949c694a97412cc5d5eefe2bbcbd5529767"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    generate_completions_from_executable(bin/"rosa", "completion", base_name: "rosa")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
