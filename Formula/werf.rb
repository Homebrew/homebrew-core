class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.241.tar.gz"
  sha256 "0a0a5999f8eca60c6bd0dabffcf18d2a63faf1274d0fe70fa0d7e15d9ec89947"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ba6539936fb9307eb84a757b69a5e7b100d98ec0da7575e241477797f1e397c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5a73f040ca85672c05001aa5b35d04fdf292a024bb8bca13081af1aec541744"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f4e1d2f5e0ddf2d93ab7dbb857b15c55b1015e17c4f8107db2585fd2f63b82e"
    sha256 cellar: :any_skip_relocation, ventura:        "e9f23dee09f8b5559e4de52cab10380990b46886ad4b7bb1858ec7ff525d6aad"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a9549994b14cd23ffea8a35a3efa9aea9840965800b0612cdf6b28b44f3c6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b393b6d4ed10e4359d991ff745b516422ec2f41e654df9c2fdec4ca4a025b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033f9ac72b110d7df4654e7f9d48e9a1ae85a0a1df91135dfc18f8140e4c729a"
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
