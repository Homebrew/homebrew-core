class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.201.tar.gz"
  sha256 "029a778785bb646edcee07cb2f4382e2722b7e410fdc71a772ccd2d5a3e1425c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda3fa6baa9b032f2fe403cb01730d1b9bf08de8bb6ff2c047fdc0068456533c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4ce649b196848dfbaa18f1184e5a73f44ddbb8ff3597486ad8d8c11e3c1bd90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4751d3328fdd92886e94dac3e9ccdf94b73f25d84a676b86a9efa62059ed2962"
    sha256 cellar: :any_skip_relocation, ventura:        "b883685eda24c19c48366c407cd0c4341e6bbfb98d35638ac68c0b64556045f3"
    sha256 cellar: :any_skip_relocation, monterey:       "7f4fa9d55aaadf308c318ef1d1fc1c9446f1d8f131afe95a004f6997377cd1c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "21d9237a3584d652e0442697a351e0520b4698a5ad38ccd777951ea1a486e2a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "443ce63d1afa4d61b029264226256083f21a6059cef877066bd534406b939a02"
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
