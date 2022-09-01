class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.167.tar.gz"
  sha256 "e2bb3feae417c1af12a740781c1c6d2c1f7d8bd3df8754474f339702252c6135"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83415734095f115e01c2ff9e52888f85eda2b2e43498c20083b693d952055eb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40e4bbf11be6bd48194d8fac59a8ef89b4ba68545c42a2a17103922ced32e98c"
    sha256 cellar: :any_skip_relocation, monterey:       "9f46cde9d96a10be868db72a59d89c13202b2364cf57cddfdafca98dd529ebdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dc863eb4048876a9dadf1eb0c99c6c562980eeefce14c5a470fd5f4e894ceaf"
    sha256 cellar: :any_skip_relocation, catalina:       "49d65444133a330a58f1f871f8ed2dc2f30ed048ad027b733aa9f4c5e539aaf3"
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
