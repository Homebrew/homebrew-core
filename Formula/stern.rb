class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.22.0.tar.gz"
  sha256 "3726e3c6a0e8c2828bce7b67f9ee94ddbedcfbeeecf9e6ab42e23873e3f54161"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b70d60729da9ae4aabbf89522296774d0cd5c72c857bca9feb9798b8b3d4aaae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "091dd476809a0005987aac1b3b504f3228ca02e47d685978cb4fc00e9a6ebfd2"
    sha256 cellar: :any_skip_relocation, monterey:       "ff3e1b21a6a10d56010f47ee3ddada080cf9486ba6854f57093c7513b9856249"
    sha256 cellar: :any_skip_relocation, big_sur:        "432ad8338d36e21c10a41e2480172fa6799eed8b7294709bafab80a040c47a63"
    sha256 cellar: :any_skip_relocation, catalina:       "d58b0773d75096a4003b2a84484c5544e5df33f492bae485f69694b3593a84e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4455d5cb038d7134bf34b9b6678a2258da4ce950a540860b0d4290232403eab4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
