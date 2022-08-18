class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.162.tar.gz"
  sha256 "8d2628483e661cb853dddcdd7863532c47dff5043d66e0ea1812a43a6ed285e3"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bf488f52301c5d0f8b3550f14fc962074412db216eb3cfc0b8750918f97adb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6486a45720fb99262c489a0bdbe05058db8e5b377c78b5c4f1629ce474620934"
    sha256 cellar: :any_skip_relocation, monterey:       "89b4c3870bb658e376f16f36b0251fd44eb40cbb02deb6c86ecd0cf24cb4beeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "497ff2a679c2865179173dec33416698311568126ce37228fa46b92bc9a16d9e"
    sha256 cellar: :any_skip_relocation, catalina:       "f21d8fa482cf0ce2d4202cd22ed9d97300954c65d082a828fd69425b1d8661fb"
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
