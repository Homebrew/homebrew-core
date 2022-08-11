class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.152.tar.gz"
  sha256 "c115dd07d32e4d83fca3820e5c39580bb1207bbba3df26580d7b9793153c87cb"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddd4d716aa1a0b6e3bae5c56692d5da7dfa40220cd4aabd602a7ad10fb4fcc1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36c7fd6cc9a2ce7d6ee4889d57e34bb00bc0baddd656c568ada9ef69c606d0a6"
    sha256 cellar: :any_skip_relocation, monterey:       "ece0e6127df3fd6df09cee55ff750c8cc1151c7777e981fdbedb0303e519d25e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3c3b9b06715c1232d26ea7edc244adf7ccaf42b165a886248865c2d68569795"
    sha256 cellar: :any_skip_relocation, catalina:       "47541ac609f38bc129dacdc54873d38e99e204f0bc077ba1f6f68ce7d17b262c"
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
