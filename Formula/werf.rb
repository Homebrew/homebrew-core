class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.165.tar.gz"
  sha256 "881cbe028e4fffca408927e71b55387869e23d4f651fcda9c2618f7534c38b51"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c529e3ab6b4af1f2b195cd06da555f6a42c8e844da8e1803a5e5a8de19438c05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9c6d44a5eaa5bfb2c386d9e73d9f781d5807d8719ea284ff4b96dbd3c7c2c29"
    sha256 cellar: :any_skip_relocation, monterey:       "2bc757646ef22e67900c99bb84b5016e0c83fb61922c1ffc7e54d6d62c2fcf65"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9a791f4fff229148111f984f20b64a1b44c8342de3ab38e0b4b5ac9bd53d029"
    sha256 cellar: :any_skip_relocation, catalina:       "38714169d9e47e632134bc4a2bc27a17c2c3b2395229b177aeb13c2fc8b7a4f0"
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
