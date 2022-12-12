class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.192.tar.gz"
  sha256 "f37d8931db551dfe78b368869f5785466a791894910e515e30d1f9fb94af95cd"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7162cd1d2029431f9f8520b3c798309c44b381c0a1c3dd4ec3ef1c4215671dae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad294ebabed26263a8cda1065cd6cc758be4ece854ffd6706c125aa7fabcb00c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76df6cc792c0a5f7ff3555d214e90dd237fe04fea3d43272740e27340f2ce8c7"
    sha256 cellar: :any_skip_relocation, ventura:        "b521d092d29da10a519bbe5fac7919d793bc14153fd800626507dae5c646fc41"
    sha256 cellar: :any_skip_relocation, monterey:       "4f9fcb3a468d36da71f0817f31689532be9131d98844b38c3f07976078b8fb83"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f0d7679b9a572e4d5d6f68cee7f610ace1aed0a3ee69e507ecdb10059d6da4"
    sha256 cellar: :any_skip_relocation, catalina:       "80ef73817b223196bb6a28a126ec7fe4e45ef233ab1d94dc7abd05dd86b62671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c01e21ccd112a7e668e0e8b897b4a269668aee0b57d59d3a8b00e8c7175bb9c5"
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
