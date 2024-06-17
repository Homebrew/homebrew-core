class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "42689f8d42a1af676efbf5d371da9dce870a79563ca0b4d80d698d8ba103facb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60691d825ba4b18d285595c3101771400d1e4956e186a6cac1a684a87f0af410"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf5f1150233d7e410c9067fda025dd907a1641bb1c27807e2b7eaebbdf8af9a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f81944f68dd12b1392eb9096164163f5ae25fbedafe40a214c486849ac3fa11"
    sha256 cellar: :any_skip_relocation, sonoma:         "31b6c2fa0628a24bdb5f53f33d9e5720366777580336949f7d24a33ef9e68222"
    sha256 cellar: :any_skip_relocation, ventura:        "203fe657a79ef7b00f130752733eaced665aa53258617889068ed7de49c307dd"
    sha256 cellar: :any_skip_relocation, monterey:       "52b9d9840d3dd4840755973081cbab4391bd8c97ac9a8155241e60ae7e3a7dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7877354314391ace266309a4e277000b9c16b5144445e6cf22fc3445158a6841"
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
