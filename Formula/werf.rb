class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "ad9f6636da132481144edaec325ceada738dea5e090986023501e23b633c9857"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8cc4fe6768731e67fd9fe28b9ccda80a42b39d153704817f3e5ddc4db099424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2324cf8804a9b3eb033fd9a0df3fb3f156ccb5ad5cebf95e61e6ac4c564b9a72"
    sha256 cellar: :any_skip_relocation, monterey:       "4bedee23afcd301f6f7e010d9c24e240363c2bc24fca49d0af80f829a625348d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ffe7fec1d1e942fbffb69228f1ffb40d5cd4139ed4f28249c65c235b0e948a1"
    sha256 cellar: :any_skip_relocation, catalina:       "fede1bd88b1520f018dcc0b3756bc719ca962875a951a2d37537571cc2370e70"
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
