class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.21.0.tar.gz"
  sha256 "0ccf1375ee3c20508c37de288a46faa6b0e4dffb3a3749f4b699a30f95e861be"
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
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=fish")
    (fish_completion/"stern.fish").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
