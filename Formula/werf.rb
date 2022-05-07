class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.98.tar.gz"
  sha256 "651b8b6b148fa03be4d8c6ff2508185f2557e24f3f56e3456aca82520b9cb8ec"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cce08993fc822eded5e285db88029cef4b3b717c2c68d9ee466bb6164cf2d25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "122419f5582e8ba3891cd256371dcfaa9d6fe309b748b7038d2ca4ab4c1b676a"
    sha256 cellar: :any_skip_relocation, monterey:       "30d7ada5d30ab1c13c3c12af9200fe68194605bcf4f2d90d4046723f158148b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c4d50456a13ae9eab60784946154786724bc224e4ddf5240ec275e2afd78741"
    sha256 cellar: :any_skip_relocation, catalina:       "6ffccd4cd96d3c5c599c52a0d3a39384ef6518dcc6e33903373f99f7cbae81fd"
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
