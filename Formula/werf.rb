class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.173.tar.gz"
  sha256 "23817f7c5871bc994501ad946ff4b0eb9da9dafc07f36674c0b709fd3a47be5e"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80c22279b8c2ba5a4288a858ca4f6b0d4afa0e8b0052a8364935cfa1a78982f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "640816e8dcbb0f9584df017abc26e710d6e75a11460c94ed6187b71c20ca3d11"
    sha256 cellar: :any_skip_relocation, monterey:       "77c664ba29898331c4b04b4e5f7165d296a78ff75fb456ef87ad1fc7c06b1cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c8399f227742f3682e5e7edeb90a8c223047d861c1456c9228baef783213041"
    sha256 cellar: :any_skip_relocation, catalina:       "70b9006c3487d9f84a5feafa8321eb895e5b22affa8dd49883f962a825edede2"
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
