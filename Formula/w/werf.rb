class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.260.tar.gz"
  sha256 "74289fa6fa55b8950ec123225bea7070432564a1fcc67f22377502b619b21f53"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbcc9792e223f84513943b864de4880514bfd865f701a5262561a5742b0dd0e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cb3244757326bc5752f5b2ed79518eb6a51b1069e416a401c727153a157c57c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82244df3dcef3c03bac01a927fd7c56dc0c75d16d81f52ef37cdb306ee75cd29"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ad8a100b53d3beb5330ef7e11a82aa8c98ee9c04720bf9f36834cbaa44377c2"
    sha256 cellar: :any_skip_relocation, ventura:        "2dd81b132e03c6d68c50e9467204b925a46ec09e473491d8a2bb59eefa7242c1"
    sha256 cellar: :any_skip_relocation, monterey:       "20c7a459dd3c5de831a108517be984bc8ced3f1c1f50a65fd39f2dc2568c8210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b915ebdd55dd8712d9d3a8e6b8cbc603f1bbe9e450f3866fea3f768fc970f59b"
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
