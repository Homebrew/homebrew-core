class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.134.tar.gz"
  sha256 "d198e3a13360437a36145dec0be5abee37c71d79ab691f40d28944d3a6cac06d"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a10222a3a29e21df9d907e300695b32bf0dc5efd3eb1a4acdf8db199ecc6994c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d755d99731216c539142839a1b93b8ce2b825f0e6835b391d78cf376346c30e8"
    sha256 cellar: :any_skip_relocation, monterey:       "1965307087d846624be522886df009371dcd5c40fe8c227609acc4e4ee6dbf47"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1eb1ca451238bb0fa3ee0920fa8081d58e1a119771dca53b7bba65ec1954d99"
    sha256 cellar: :any_skip_relocation, catalina:       "1c432443ec964c246c836b072ac9b6318f0ea1b3be2a95b8d063ebd6032329c4"
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
