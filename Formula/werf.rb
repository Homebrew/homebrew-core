class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.101.tar.gz"
  sha256 "3f021090f6f04f68af6495efc4f17df3924be0017da61290075d67689db942e7"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce22633f0af1f8778ac4b39ad4fcddf40f5491496db7132ea3616c43e08ae9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd9ad3bbc3ba4dcd22d49fc26da9f8ef5946058ca011a5440eed0bdd3c5acb5d"
    sha256 cellar: :any_skip_relocation, monterey:       "e562a79311b33264e96cedb4b742ee69e256641dcfa469e5f91e8cb352fabd2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "09622e3751fa4afcd48b7ded2e016d765c679b58c15962573f88a913cc45c08e"
    sha256 cellar: :any_skip_relocation, catalina:       "961871e84f1aacb7988263269fc0ecd0a77cfd723cc0d5086e8b0ba7e7fd0371"
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
