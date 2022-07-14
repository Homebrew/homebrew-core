class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.128.tar.gz"
  sha256 "f43b0273bcbd1583fa84fb530ef24262043a459fff8cc9e818bbaf07df656572"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "412b9595f57e05864f3466bcbaab146512bb85670d1445f877856fa8f76eee71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abc1f84df676b1db8e61a74bf6de90c24efa90d8b5b75a70b1ca3ec6843ee795"
    sha256 cellar: :any_skip_relocation, monterey:       "1bd88ef516a3c9ecb6aeba141200cdf30bdf8a3b4e33096fd7d72dcf8966c1dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "33f7af5b22b0de9fbb1dce9a8aebe84359f0275f70256eed91c1fcdbfe7c3619"
    sha256 cellar: :any_skip_relocation, catalina:       "3db5d472aab8424df4e3782bb1072ceffdc3b674aea998eede9abf63d5c6e391"
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
