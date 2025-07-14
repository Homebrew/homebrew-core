class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "fdc6f3f092d0e1ac418c50a64eb56f86eb98ccaa7c57b991b48962944b6507d9"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e661eb7a2df051da83b7f55a6860563ab79735164999cb93f5b65924f6c7f600"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99379a832db9de4b8450a58eea982fdc10aafab29a4b66c7a85162c801cf00e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dc430584cfefe47a87703500f3cc2c1b5b082667bc2366ebf00288dad548dbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c6c66ad074988bc09c3413fe84c0acba48b4eb6bec09bf43e9b6892b9573635"
    sha256 cellar: :any_skip_relocation, ventura:       "8b188ed29f8df7362b0c5a30cda8c5f71d7d7b6dd6eb1a9ddad16e5b421f89d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc4c94191ec98235ad836470d002a5addebf777681dc289080a46fb2c0c7875b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be319317b49a9b553c82b894e87b87947e3be7360fea79445a16ad9ace5c08b7"
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
