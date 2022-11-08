class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.188.tar.gz"
  sha256 "7c027b93b45b3e46b2619f4f59539b92a1baf1f5bcdc319862a5944c5e1fccad"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87dba29bb0c6bbd7498873155f9e6b8723a7bfa0e1ad300eadc1500a23e401c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14303608b02f8a13015dad1284acb59ae92c23b0fa780fcb1876bb3467d1468c"
    sha256 cellar: :any_skip_relocation, monterey:       "f701687cfbb0f5bf3f6e15e5be3cfc57d5423fc7bf7dc6eedcde6114f15d5b8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfe04eee0f2be3c952571646913d15727fb52945835d85b2e6f373a6b64d7303"
    sha256 cellar: :any_skip_relocation, catalina:       "468ec3649625a63a5d9194841f9defa819a9a81e344bf48a33a917fe4b4c2df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c153c4a05659f599ec59fee6d566eec021c362d0dc0e9bb6b7f18b5272d7fd76"
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
