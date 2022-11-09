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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d32f7b9f0d2ba3c13d0ed33ec752955f44c6394e8a39bfa9ec90ab92f524dc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ba6243c05a9ebb54250eeb916e41d7bf1906dcfcf35dee3743317d57b16e038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0023450b7098de0d8409a8b695539ae054628494dab5f0c7eed87424ed652ba"
    sha256 cellar: :any_skip_relocation, monterey:       "309a32880602a13b8d7892c3572bd6d7f63c2685f47d51dcfcbae1073215a920"
    sha256 cellar: :any_skip_relocation, big_sur:        "99414868f5342ee033273849047106eb043a2c4e2c307730209f9719fb5fce0f"
    sha256 cellar: :any_skip_relocation, catalina:       "8cbc67ee8f48c1d23c05dca631eced0829519caa3f43cddb01a7c473524fd31f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b597b7f0f0961b84b8b222ea0534afa1d106e1c8ca27a9f6f9bd6407125b5b31"
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
