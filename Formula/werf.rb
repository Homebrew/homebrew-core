class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.106.tar.gz"
  sha256 "3ba20ce1138f3a96e90c4e4b030cae04098c46bd7a17d110390f8809f7df6d70"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "657b4c5e673f4825b6c9d5ba3808efd57f71735b6b6e1f455bca06c1095143e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95f05409673b0dfb9c2e20a78a00145801123bda4209b005e0bd7bf9996d5663"
    sha256 cellar: :any_skip_relocation, monterey:       "62228a952a330f03f942da50eebae4b7a2b00ba9c807c47117129104c9c979b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "39104b1471b2b393872af80c4ebb42837d5f3fd4aecfbce9b046885168905ade"
    sha256 cellar: :any_skip_relocation, catalina:       "ced8b6e19b73c262e619e4ad97e186cc38409ea231767ea95d87d01a8cb6cd3c"
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
