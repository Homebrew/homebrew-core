class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.253.tar.gz"
  sha256 "546ed32ea8edf7eee51d442971574235b53c3198df6bfe1c01f5aaa00e02a4b2"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c382eca112b0f0a743df96c273d721102208b7cd727f08ee9b4206484a53b0cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54810fb15424cdcb36a6ca79b875f275bdd629932a4deca7c7ffeac4a6b3fa57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "989c93959f60f613fb49dbb9fbff6d41e1ab214ccb081abedd07338c9408f3b4"
    sha256 cellar: :any_skip_relocation, ventura:        "fc811915eb7993e041c31f9a37aafb24fcee256c8f1a6ff24dfe841890ba914b"
    sha256 cellar: :any_skip_relocation, monterey:       "df96fd9e7104635fa21e0c2b7d34dafde3345537a6472cfc0ad8306e1b661bb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "40528f970e1ad7de613e24db77e1d907bdec0b95b56628cd765052dc7de84697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afa4c77e0bc91d0c11d83f9ee12c5506746cc77d081bb0cae939a7442953b0b2"
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
