class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.199.tar.gz"
  sha256 "c45332e71c0c6924e630bfc5afddfbc7c81093fa6b612fd52d0505cc5593cfd5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c6f83537d73fec3954c4f10e7c15045a2c0e0d47b5965a1d666602fbd7f5226"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecdf0db1cc3cb497e8bc0e161cc1ffcafe0566f75764d1fe9358906e35ab0c17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecb92812772a915e6263132c6e00904e5c5bc4aacf77fff50be5120128b69f00"
    sha256 cellar: :any_skip_relocation, ventura:        "652a8d54a30e66e8704b87df9023f95dc62a4b98610aa39612ba976be29b2574"
    sha256 cellar: :any_skip_relocation, monterey:       "00a4907852d30c3704fe5f649eaadb36a9efb99e046d215efcad7f2945a7dcdf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d397d909ef938ec900e1c7753a0e2713486a245bce0cc158e54ec49c448c6faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a7c2cc530eab054f72f7cad2596ee6cc4259dbdf83b3f25d91f1f8012e5c9df"
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
