class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.36.4.tar.gz"
  sha256 "4e085c5f00aee601e9ea7db6f4169352526351ac7a24a28c749ef08069426f77"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cedf99c4e386576305a0920f9e388d29bd99bfeaf3212ae403967b118171cbfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32399efa6460ed3302325666079939bae438b8f93ff6db275398a643ae11b54b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68aa908eaa71daf71ca532089e140df4b030528040f278af7e11e9aa72b69942"
    sha256 cellar: :any_skip_relocation, sonoma:        "fad2363287e25e7e4e6fb7f63ebf760398caee0526077af9166700eb5ee2a0cb"
    sha256 cellar: :any_skip_relocation, ventura:       "d56751ccea145c39a08b1ab8bc6bb5ca881bb1624c420ac2c69fc7155b901e29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "257d8916d437ade241069afda5948244735edda2aeb30be050036f605f3c2e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee88cc5db3c4d393992d4e1871c4484299ddc2ef587bbf2c4112e6ac103574d3"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
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
      ]
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
      tags = "dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/werf"

    generate_completions_from_executable(bin/"werf", "completion")
  end

  test do
    werf_config = testpath/"werf.yaml"
    werf_config.write <<~YAML
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
    YAML

    output = <<~YAML
      - image: vote
      - image: result
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output, shell_output("#{bin}/werf config graph")

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
