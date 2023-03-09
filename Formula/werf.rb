class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.207.tar.gz"
  sha256 "1cce5d3323f3efed19066749f05a83d69c99823150d3e5ef2d18d0b499a38595"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3aec29fef1a458a17a8e3cec80b5bac43b8b0a4c2aa0e21fc6a2716925c8aedf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56e69a3f9688a3dfb2d0c0af54eefd008da502845a14b9ddcdb83425728ba875"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03f09acf254ed37cdc917ca27de0cddc62c1e10b01d2ecb5cf28dc3a9cdc2579"
    sha256 cellar: :any_skip_relocation, ventura:        "d4e419a3887de5a516291af1c853fee122552d7321678a6d4e8e35209a45c5d4"
    sha256 cellar: :any_skip_relocation, monterey:       "069ba6c3bb1f26da8ce429ce514d29a688699170540d1fd403a1f24d69981bd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d24fc6d7932fb2563e1c8ff08cbf955d935877396289f780f49d7154c7542fd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a71f208c08db158e68cd7fc34d3dc98c65797b8f3e191ae0fc5aa12118f90ae0"
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
