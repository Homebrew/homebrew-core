class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.15.tar.gz"
  sha256 "d9e10c7f4a56c91d14d21a7c8f7a1c62dba4fc02321f28b6b66b2926f89aa528"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0690603f4a8e3632a8d2f78a6d200d523aae37553d815b60c07c6a612d85b52e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef5a49ab54f44480ae1ec5c95c68d4388068dd8c1dbff7ce9be4aaf87eac3b1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "907e622b7143801c33b9847a08edb21ef7459d7140724d4e41a5b1039d375f0e"
    sha256 cellar: :any_skip_relocation, ventura:        "f08e67bd54461b1d2493cb4900f7daa41545690895df193c517d405c3fc470d5"
    sha256 cellar: :any_skip_relocation, monterey:       "a7c34982107e1b715cc8f8ae2b828c8569d2f59d2021614c5dd00948b5d688bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "394e496bfdd760882b999e274f25ab0a6221f5e6e4c4b15764aab1c1fd1d7eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc90fbe67bc20ac3740dfb5c33cd65c70d72a7fd4b8e52c20366bf8258bcacef"
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
