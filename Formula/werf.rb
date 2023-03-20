class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.214.tar.gz"
  sha256 "b50205ed03fe289cff79cc173c6b3b1e171c0a9ddce6ffaef5b06fd86a80a196"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be4bdbc971f02103a62978473160055804904d228e0db976b9f3b8f1e9b30a20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd7b846f3d3a4ad6ddcd38538f291de522bfcb3f3670ada96cc783a1d5ba214c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf415aa093ad581974f97ebb070168e90ca276b93a32458da6274afca6db214f"
    sha256 cellar: :any_skip_relocation, ventura:        "a0474a80fcbc5055a44be282902ecdce8f6070088dd01090948b9ca4ce9f4cac"
    sha256 cellar: :any_skip_relocation, monterey:       "d21f8e454734e87cb3346b56cf6ee4d6792a3606a5b4561c0eb863b35202733d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7528a52f24556994544c11d5c7b6b492356e5bf5b0b2e20459b015a9c7ac0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494417764959e00fd91c61f81a9b76f41cfbed286dc669a73c26205717b0603d"
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
