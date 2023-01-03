class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "3803366e86b54900281a610317543a873c41e25012f0a111e36d6c9257da4d08"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c4d0cf16443a8fc1f75ca4bfd2faab6a2ffe560d932ac5eb2c2720ef0cda172"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd061029bd336b7dd8fc7fe9bf901e0134f31b279e987073264d731a4d0e6bde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1addda07a9048f7bc6934b1921564033d96ce9748ccac7b07dd098daea399c3"
    sha256 cellar: :any_skip_relocation, ventura:        "cf8c00bc7c322373393f8286af9c319a99c44e1a3fd5ff5c76d922fb09d88320"
    sha256 cellar: :any_skip_relocation, monterey:       "1ae2053fc982d5f478e21b9cc6d391e7ab5077811d3115dd2970d63f4b2e1e8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ce7dc39f934322269ac96f50e278eed227516af92004e0745281bbbf008afb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548adf4416356667fa87f5a6371afed5e8d2ba26eb1c1cf8c5f0acbf438fd80d"
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
