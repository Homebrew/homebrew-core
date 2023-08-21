class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.252.tar.gz"
  sha256 "49d506466952aa5af840c0c75f836c6286f7aee613aff5fd84a4f8d41e73ae87"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3b9da50b0708806634506eb0341521198cd9fd46aad5db6f98c0efc7ac537a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f64e743e9df1e2d50486c8b5802f786d3ab9bf53173952906ddeac215c98f9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d5d771fcf3dd3eed7a0a3547086e1f0e4522cda10597edeb9efdeeefbf68e1d"
    sha256 cellar: :any_skip_relocation, ventura:        "a7cb83ab9af6590e096204da5decde3ac786467b1e74c981396f43a8a08f146c"
    sha256 cellar: :any_skip_relocation, monterey:       "20732fad007413aa8b451914e1a18a59b98eb929e23e57a7505bfce408716ac8"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d6a160b0d6296b013ebc285835b5e29b5ac73ec1e6c1b86a8afcff63a7e0288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66eb8f37967f3ae6e86a0511fec9f3ab8ea9bd683f1d501dcfc020dd30af4df4"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    if OS.linux?
      ldflags = %W[
        -linkmode external
        -extldflags=-static
        -s -w
        -X github.com/werf/werf/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

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
