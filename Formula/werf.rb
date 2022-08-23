class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.164.tar.gz"
  sha256 "862e6fefc66fb9b9fb7812e8a1019f4f8c02c302ec47201a08d9f1113ecd9b2f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3aeef9f24253223509e20981cfb93979a05a85962fce6a5570a4fb26cc1606e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4787e0adcaaf38a9c76f9da74122c4a82a52cb0f40a356ef1599db6bd90b87e"
    sha256 cellar: :any_skip_relocation, monterey:       "6dba96d70c149db168362c8c1ff2accd63291b1b467fa3f402206d95c741c79f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6db3923b5779f9586d7f16761abcd3025554ac72a250ef8ac75eab2f8a3e373"
    sha256 cellar: :any_skip_relocation, catalina:       "b7125bc3c52c58264fd16c08a5eb772c2691fd146a768edb409d237cb9748fb0"
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
