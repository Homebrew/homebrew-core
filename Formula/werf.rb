class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.94.tar.gz"
  sha256 "e04b8bb6f020d3576b740d6d297f599812ebe4cb95c8b048b2e07bed46aa1640"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be2fca43f89a39041946d710ba598bd88be9f16acdb3fa8b18a0799cf6915bff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ae930aea47fe4a8f5219e796aed15c5498f49715446f986e525b22a8ed60bf9"
    sha256 cellar: :any_skip_relocation, monterey:       "fd8568c7f7a08882047ed5add2403e32d53fd7b15b45675d8b180615f0a457dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a5bee4b15a1995a5c550e04084ac8e9bb359d7d25684701bd494531d23e6b7b"
    sha256 cellar: :any_skip_relocation, catalina:       "a869bf9c13fc12fe9047c3a613fb6179421449062c3dbed3d2863bcf0761cc96"
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
