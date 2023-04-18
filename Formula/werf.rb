class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.224.tar.gz"
  sha256 "641c6ae9a95cd123f4e4c1123456d1890eaa7dc785bf21de0f2d31cc9fce4cfa"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad812846d7c7a59405240c8f1dbb3ecfaa9c14d89043d131dc12f3e0ddf0eb13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ac75a7bc0965f93b66607d8c4dc6c7f19ee2ed44ee1f878b958bd2fae89f19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da19554162c7228a963519a0e0208fac9a5931700383a0abae8ee19501507e37"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3d3fd191f404d714ff3417557a5c488ed613d71dc4a64a3eba68d0f205334a"
    sha256 cellar: :any_skip_relocation, monterey:       "670b9c9bf34971c3fa6db8bade36531392a78345300252ede6f1e94c77466f3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "35ad1c894c0c6484a10d9280675f8200525d24253e7528eb6c9db33a00559031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28cef90eacf42376a68670e1bdb598dd208ff6ace169ff399e9ef9edaf8ce31a"
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
