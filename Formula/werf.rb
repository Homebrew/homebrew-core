class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.111.tar.gz"
  sha256 "f2001b76b131e3dc48bc56a46e17083a1809fcfe6768aa6f864fc7ae22522c90"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94680f2ef61a019580565800d67aee2abadf5e2eefc69dc0c4c7c23a937997bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab3f299af1fadfd1b45893dd90e9b5f4e44baeb6e2f1c50834443aa97beaae3"
    sha256 cellar: :any_skip_relocation, monterey:       "4936659fcf068924d09d879eaf50d96a2f8ecc4bfdd181d46aa0e232e8cb0241"
    sha256 cellar: :any_skip_relocation, big_sur:        "95158eee279cf74ac695a3191f7b1a72778c9d559265790418aeb27dfc8d56b1"
    sha256 cellar: :any_skip_relocation, catalina:       "3f8225c94c86c263cc7702cf77a28dd16f849c36bcfad5df23b7be3fd680926d"
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
