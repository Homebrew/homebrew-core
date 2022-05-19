class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.103.tar.gz"
  sha256 "5f9654ebcd07323b1b55908841633e2fb90cf43883974d7fe1f54678631025a6"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a972579776e41a43658bdcdc778942ecafeeed6ef256e30e4e2b59c42ae3e5ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f92eb1171a6431c2a0d044de65ceebda2b2d9332f5b4836ae96eba07172df3e5"
    sha256 cellar: :any_skip_relocation, monterey:       "78d45b0991d89fd6c01b0da7658ecfcc444714074075154ab194501f48e2f5cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a48d168aa242f57ed2d44c5e225437652a8caf6ff6517d244dc5d86442f659f"
    sha256 cellar: :any_skip_relocation, catalina:       "b42e6449458f0dbecdf34c04ebfcc7a16da68ffed14d014c1f98482aa56150be"
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
