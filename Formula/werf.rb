class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.144.tar.gz"
  sha256 "785035eda4192adf12fc78414f1ea125f90c59183387ec4f5580aadde4d28391"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6adae58b7e905899c70bc25beb2aa6bf88d6e03cca1bc5d46ca968370be3057e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e58ee6ac56b1c4904f87500bd71d6d38b50ca1f5a4a0c27edc0d75b689f1996"
    sha256 cellar: :any_skip_relocation, monterey:       "7e2d49aeecd1abda20d1bb220cfe763286f75a5f0c00afe8f8ba7711c8f5c89d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dcc880359349be1019a0af829f14103735c18577d1c34c251904ec46ff4d334"
    sha256 cellar: :any_skip_relocation, catalina:       "2402ff36f9335c52217608b933136e22c7792011f286d73e72a21815f0690203"
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
