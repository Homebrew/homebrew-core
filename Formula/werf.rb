class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.117.tar.gz"
  sha256 "f967d527c6149c32e4cd1985d4bea68a6c5f726c01a158733900c4932a94ca23"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a7cb1380c2db8bd314ca2166c4dd01208afa75b24c27418700180971ca69fc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7beb1052df8c98341fd44dc5e86311416b99e013bea39b1b0bfe68cbe9add671"
    sha256 cellar: :any_skip_relocation, monterey:       "3a9d6d2a4eab69d15bd26ee0fc126f744c8537f896e0a4988ee9ad480e26c9c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a769a45e9c21be659d97700f23f2122316a0578bb503339e30f87b7947397e2"
    sha256 cellar: :any_skip_relocation, catalina:       "6bc164a5e877ef89e000cc072302b1374a5d987236a24d0782b51f0b4be49332"
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
