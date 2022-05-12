class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.99.tar.gz"
  sha256 "153d88ca7d5007b3952bc3802bb16ac02477d439602cce04e89594bb3efb4734"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d817f88beffd50780681116b33a462a52369bea9d25ba1e33a5cddd2d3b8afd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "436fcab84df92720a87972df5125f51a0853e3a5e0e9b9c57653872d6972e496"
    sha256 cellar: :any_skip_relocation, monterey:       "29282d77045ee99f6c57c00c429b77cfe0b7b0bf7d23ecf1fa154d58c794c714"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e43cd388f15fb52b48764776b0cc61c033f8ddd752eff74cd45bc0acf66a7cf"
    sha256 cellar: :any_skip_relocation, catalina:       "d02bf883fd518a7ee7db744f2cea10a9e420310f7ac0ae4c71e3a049e1114327"
  end

  depends_on "go" => :build
  # due to missing libbtrfs headers, only supports macos at the moment
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
    tags = "dfrunmount dfssh containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    bash_output = Utils.safe_popen_read(bin/"werf", "completion", "bash")
    (bash_completion/"werf").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"werf", "completion", "zsh")
    (zsh_completion/"_werf").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"werf", "completion", "fish")
    (fish_completion/"werf.fish").write fish_output
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~EOS
      configVersion: 1
      project: quickstart-application
      ---
      image: vote
      dockerfile: Dockerfile
      context: vote
      ---
      image: result
      dockerfile: Dockerfile
      context: result
      ---
      image: worker
      dockerfile: Dockerfile
      context: worker
    EOS

    output = <<~EOS
      - image: vote
      - image: result
      - image: worker
    EOS

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
