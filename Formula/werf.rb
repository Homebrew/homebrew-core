class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.129.tar.gz"
  sha256 "99b26d48506d812c372d7108b10828e7a3a884421a7952716da0fcaf50953b57"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  # This repository has some tagged versions that are higher than the newest
  # stable release (e.g., `v1.5.2`) and the `GithubLatest` strategy is
  # currently necessary to identify the correct latest version.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5dd52f2684fad055ff8b5812c2c600fb515e8abb7069ffea5d8fd0fe8ac795c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d21e2cd7f8f70347b715519c5831404df06cfde3960c7b40360dbec7a49d94"
    sha256 cellar: :any_skip_relocation, monterey:       "429de8cc0491b14958581f79fb05281b75d2f595bb99c6fbf38cd60cab4cd7c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d833f202305ac8cb8a4901ef5533bd047635f576ffbbe7ffc5885f6736821033"
    sha256 cellar: :any_skip_relocation, catalina:       "506ee3f64a4cf3a16a791b8c6a2c779ab943b8a47a53f5f69b140ed9c471b55d"
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
