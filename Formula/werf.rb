class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.104.tar.gz"
  sha256 "9eb077167fbd810ac28e661ae7193bd3d58ce58c6e6651a9948cba4a9f818712"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a718565845da9193ec5bcfc2a9b5b94446d38f8a56f8a9502dfb021ea00b3f6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19d496749df8d0e69d618849ea43f88cf93de9a21393038230d9585726584b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "58acf524f7f93c84f3a54351e92f1f1511413d2c0c747d2fdcbb2d3868c8a9bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "24d3c9bbf01b78b9d67793c5ca9247d004b77f01dd12c8e8238750b949a99722"
    sha256 cellar: :any_skip_relocation, catalina:       "2b74c536a77549b3020400bd98e4e18a3ec6fc773de1d79e9c271dfb3af974f9"
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
