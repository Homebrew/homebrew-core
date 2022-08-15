class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.155.tar.gz"
  sha256 "49cb19a93cb4eb57dd46a1572e2066853b4c9fd0b8d15c970118bcd1814e9fca"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "083806934ed70c4986851e3337f3a0264297d582d396c87b937694ef5afcd460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "727c5fd99fe8834121d631327ddc4949a8f2dbe3a3777b6236d933723a4114a4"
    sha256 cellar: :any_skip_relocation, monterey:       "e91976b3f76af974b6b616839516c70607bb9608b11c9b6f45ebe033aad6516d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8397b4aa40e24006b6f0bb8d182f637d922a6f3e66546da84e019a5c2f9b9f1c"
    sha256 cellar: :any_skip_relocation, catalina:       "5a8c5e16617167c23bfd020153adfedc4ba5cd215bded88f13dc3b318ca4ea02"
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
