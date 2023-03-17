class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.213.tar.gz"
  sha256 "47981fee0a06ed57210552440e5b77cb7499189e42de9af5f55a237e9a8d2591"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70d3a9ae168646b9fd2d3cc8c94d971cdf6e9ad8f604270b7235133a26cb43d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7596e111d4dc6c97fc4454542e0910ef1011e81135b2ae4b3a990acc6d64bf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80517f7b42847cb7353a2ce687cab923446bd2bafff36dfd703bdeb5ca2b3bb2"
    sha256 cellar: :any_skip_relocation, ventura:        "62c726a2faa54a85654aff6510a8e421098be04f6bd8ba0f8a1125a96d567436"
    sha256 cellar: :any_skip_relocation, monterey:       "c8de04564acc4e53c721b3dde79bfacf9fa56b446aff0eefa3dcf33fdf90c88c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8948321ea487982de1a67ecc6213ba7fa254aa7c8c760c8a9ae812ee1b42bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae779ebc69065591acf91d767046b1b123b8ac6297c6fca2232a4d2155ed572"
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
