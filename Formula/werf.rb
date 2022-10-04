class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.177.tar.gz"
  sha256 "c0f8230371e8bce02b4c07d3d98095851723db1d2bb138432406bebf8ec7b001"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d6cc7c3e80a507d2118aca987176736ae73c4355f7d5de7e0efec93c9c185a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ed6bf0c0698e802926f107404f4cd4238500dec0aebcffc9f6161e86e539771"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9702ab54f33d674a19cee1f1dcdfd0dc339d96c28cd81dec643162cf6f2f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1baadee04f2642f009fbc3c339e64825bbda122cad2916853b5018996f70217c"
    sha256 cellar: :any_skip_relocation, catalina:       "15eabb8fa18a3f4edb27ee93dcbef0e0f406904caef392ae08a333b861f56972"
  end

  depends_on "go" => :build
  # due to missing libbtrfs headers, only supports macos at the moment
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
    tags = "dfrunmount dfssh containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
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
