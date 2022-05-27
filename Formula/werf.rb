class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.107.tar.gz"
  sha256 "1723e50f2e146443b10ab109a09dd080aac607932ddc8d06db11e95c8e3677f7"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13c1a0c8436dd41098030570a94df6dbdc4bc55110b1e15202935505d215c5ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f25c53761f452fbef2bf83a41f42f496de6e502900ebe4496f638e558eee858"
    sha256 cellar: :any_skip_relocation, monterey:       "9667045e01bb653873b9f97a6d60e869f0ff985cc05e501d1c75726ed88a1abb"
    sha256 cellar: :any_skip_relocation, big_sur:        "abc5d477a455c88ad0e268c58dd8e56cb0d53c3257fddb0465d1dd9e6f4485bc"
    sha256 cellar: :any_skip_relocation, catalina:       "d3e4a11f2bb9fa2bd21101aa46e70b8ef513acbe58a71c4c1b7a99f7ef932abf"
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
