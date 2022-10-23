class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.184.tar.gz"
  sha256 "27fb874542b7449291d9fdde966338ee473fca47d1245b14531c2c56275bdf6f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f60415f05e1d093231f3ef60ec95ab7b151904b50c02153ec2af1ed7b485672"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1c80409b5b1556cfa897d1eb2740c3a18e035e101c61fb38a1696c19858a319"
    sha256 cellar: :any_skip_relocation, monterey:       "b0cec534a10dbfca2818e9e13ca2c98043c5dfd50744ded9222f86f0bdfd5d7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d643bd05668fcf33d41d0f846230a34b92698e5f80e29b1a7a587ad737b5308"
    sha256 cellar: :any_skip_relocation, catalina:       "6822117d9e026764db21bb3a040e8b6ba9151654f31a46e295b40757ee1babdc"
  end

  depends_on "go" => :build
  # due to missing libbtrfs headers, only supports macos at the moment
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
    tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"

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
