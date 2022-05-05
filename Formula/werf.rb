class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.95.tar.gz"
  sha256 "bec0a9bbf0d6b086f020ae2095c378c07a372bd379c7302cfe8625b90cd3bbbe"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c5ac7f90d1198659a4cf6a5bf935b745a0146a3e8ddabf8c9ada08ed692579e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78cf2b3f8892de6daef0580a9d19de92430f041758fde81a4405e674e07295d3"
    sha256 cellar: :any_skip_relocation, monterey:       "e0717ec0073bd3aca4c6f364733e0bc24a1182a4bc19705bcb918672e1ef0235"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b2402707ed6ddb4e9315bea0924d77b3da9df82937e8720bb7f0866e6b37012"
    sha256 cellar: :any_skip_relocation, catalina:       "90e5dda5cda7673cf99595afda9a941b01f52927954d61b993ed6721edbe7308"
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
