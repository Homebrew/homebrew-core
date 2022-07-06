class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.121.tar.gz"
  sha256 "dc8dddc2fe56ac45e480879ef7bf1bb35bb91a348cf50d521f4da30fefeb1fda"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7ad7a7522b2e57c0d52f68ebd1c6cbc9f57ec4a37f4bc4ffce4247b35cfb950"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa618e662c73512113968c6f19273cf928a2173da7348c02c4801ae9ed92ad97"
    sha256 cellar: :any_skip_relocation, monterey:       "05289e731c7946489f06c9691371828cb05af1f9fc41be7917b57c1a46028f25"
    sha256 cellar: :any_skip_relocation, big_sur:        "cab297207b0a768a9ee50c56cedb1ea4b74a09317853fe9b4050f4810d8c0031"
    sha256 cellar: :any_skip_relocation, catalina:       "344ab3ad5bf3d83bb6a2b93b8964654d37f7cabddf2be32875f58fbfbb5ba28c"
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
