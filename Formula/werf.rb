class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.180.tar.gz"
  sha256 "f69784435cb86b90ea9979fce56f54e8ad4129e7c26648646b4b329e61cc7e90"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97157a0a178340ce50ed7752a9d239c53269673a78449820e707d947ac8bab35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87534e6563852a19cc0de2e4fd21b02bba80c41129197f978355e07bfd058488"
    sha256 cellar: :any_skip_relocation, monterey:       "b55ab3166aaf0939f412ac0455d616f8adc21db54cf784dab2ffa874c1cdfcb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d217457a69d1068f0cc7384249e668a260f9946369064c4bfb8b069f933b992"
    sha256 cellar: :any_skip_relocation, catalina:       "f27962396f0af07364d0e2426dac65b479731abbdc2d8565edfc727dc6b9b55f"
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
