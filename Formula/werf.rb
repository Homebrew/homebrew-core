class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.212.tar.gz"
  sha256 "5cf0ee2b3f7edde422f92f554fa064249592cef9b2208fe90907aa767b40159b"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a7db2032c07fff8dfc2491ec592560e7fbf6ff99a3d343f74d6f517430666d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeac508a8c473c1e67f3884491cf74e3a92c326ea4f9d56d94470d91aeb3f04b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd45a66c5b89f7037418762899b2000705ae0bcd91a776a69f93608fd9ef6a6a"
    sha256 cellar: :any_skip_relocation, ventura:        "9364f04f0cfa8a1522e1897baa14430c2d877391f49fc831ffc7855e2f1de130"
    sha256 cellar: :any_skip_relocation, monterey:       "4e0bd1445118ca73e5e45128d4fc4a7ee3fefa645d4c189dddcb4da2dbb863ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8a25cad3faeb8b4f6c138292b0e0c846d4ac8b6b8a27d26516fa90af0b8bd8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9283e19342536a6390bc85d42a29f01208de7189213f9974ae75b329676392a"
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
