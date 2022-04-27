class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.92.tar.gz"
  sha256 "5a970662b971847e9dada5a8000dda686397f114f7ca05360dafd8ecda79215c"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00bbfc1c62d5bbde610f381f9e33bb1560c85eff9d851d821366049bce9dbf85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae2c83ee9cbb8ebf3151fa55eb4ae14d4f0e290f57f899b170fec2e7a4664c79"
    sha256 cellar: :any_skip_relocation, monterey:       "413c76a9e4699cd3474d3bad8c2c131f262aca77d990ea4a4533be98234273e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a8be442899b191983b897f3ecf48e7be8b0645e38d86f1c506f467a4d422529"
    sha256 cellar: :any_skip_relocation, catalina:       "116a3808f7aede9182a711e48a7f5b9d063852887eb5b2ea0c38bc2e53a3297f"
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
