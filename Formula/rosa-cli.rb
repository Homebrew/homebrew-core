class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.12.tar.gz"
  sha256 "ac862b0e15a7b482573e47197d94e010ccfa2a5b8d1a91770567f60518138a1b"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b1e18c1e687ee30b43b18e54730d8823d31c9f5474299891a464f4669cc97f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b81ced65b719f035dbbfa25714e3a3c32db06d2d16c417e7bdeedc05ff88ff5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc92b0f65e8efa68ef93db7579782f73056491c0db71f9b584da1f2cd143f665"
    sha256 cellar: :any_skip_relocation, ventura:        "497ab179f85526884e51c4d628a01f25bd5e95ba352108a3c247937ee8d715ef"
    sha256 cellar: :any_skip_relocation, monterey:       "bf5528c109bcfd1e14f788caecdf6c4db24762b371efd5e667661222d7d34914"
    sha256 cellar: :any_skip_relocation, big_sur:        "96b99a77ce64d0c5e533cf52a91125c4b498a034d492fe65a92842958a3114be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f32b6db1c98f903ff2fe303cc230c64039cf16388b66e999eca21e5fb7d4a8"
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
