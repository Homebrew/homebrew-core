class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.10.10.tar.gz"
  sha256 "7d24efbe202599b036adab31a376b5c565dd64889c72c60860fb4ae72794a0b5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "482bb332d80d430fd214e3ab790b657738317c26e31e7b1db656c4711f34e8da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2251610dde5c884052d9c0fde82bcf8e3014adf1dc681f5530542625dbda7f6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "234e187d6b7187b339274546159e586b468b22fe898dbfdcd839561e067c3f7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6208200aaf148b616c3a7e238dfea765d32718ce16a0ecc2539d73ba3b8d814f"
    sha256 cellar: :any_skip_relocation, ventura:       "cc6f1d3aa29f1fedac035bbf862d600baf0f726b6334c893e61219f3532d49fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6775c6ad565f210dc2248970159377d9fcc5b19f60571927444b2a1c3742eb78"
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
