class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "0d87f199f58353f419a28ba13ce9ad34a5f1975c83889391238ad3a60369d813"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4561a69a6579c67df95c521150baf858a742ef5f176af0bf28baea06aae4b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f491ae566e4ddae24f7d363f94e8d688625bd1f81dad65ca6ab777306a024dfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5862d2dfb077fb2ca7978dba5a55cf7f3fb936370d59fbf63d322531331cd4d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e38fecb1b6ec7f0365652ba3a3518a0f0391e0c704c36d33c6589efbc8a6ddb"
    sha256 cellar: :any_skip_relocation, ventura:        "baef703e622afcf8faec945b968f24de29521b461cde3fee923df662662f81be"
    sha256 cellar: :any_skip_relocation, monterey:       "f90d2a4ff1efb45d1891f51c4c21a064326706ec11a413423a3c9abd36a5046f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "839908b8cac99178f3bf14c1b5f5fdf7cc11057bf54c21b5ac60251edc75a888"
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
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:), "-tags", tags, "./cmd/werf"

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
