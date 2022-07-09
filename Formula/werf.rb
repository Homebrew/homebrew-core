class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.122.tar.gz"
  sha256 "be5868282e2a003ed2ca5e149c6a7cb50ebcd2d48ca7a7377f18b0553b6a2e23"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54717a2361c4ed2dbb70122d5ac4aad3435249286b866d0ad9cbcdbe2805ba5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b70ee73937ab6130e2f851da72fafd5e3225eea05665789bea030da0f22843b"
    sha256 cellar: :any_skip_relocation, monterey:       "97872bd918e278bed62a3b1f6a31a0b5c015a54d6695bc29117bccd48ea0fc55"
    sha256 cellar: :any_skip_relocation, big_sur:        "672a8c9bde5637089d1741932c4a506e23a72cd567436daf1c13eafc6ded9429"
    sha256 cellar: :any_skip_relocation, catalina:       "f6a84ee712f211d7ea7bb553cd2596f8173b176f45560568decc98b22a95b420"
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
