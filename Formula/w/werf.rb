class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.297.tar.gz"
  sha256 "762d1c526b06eaef84e014df6056cc4a1f4ceb4a07e73fef2309ec9d448654fe"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd68d8d633e6862dc5b8832cdb008d428502a8fa31e099f443095aad59e0f80d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37f96455e37147135e86fd9ac860796943a62a7235b0a4c1146acde586c2e3e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70b5f9b736bef09602f00647cca2c3b29469094636a9f3b0c24907024cb901dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "25176da12b8a3c0a76faf4665c85211fde3e66498c895304566bb348e5b9a996"
    sha256 cellar: :any_skip_relocation, ventura:        "4ac94cdddc2ca0767914357c23920680b259f4a42ffdf4fcfcb76103e78c842c"
    sha256 cellar: :any_skip_relocation, monterey:       "0948ab10b5faba3e457df18440718572cadd3688646dbe45113fc717848b5cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41e3aa2c7db9eafb4345fd5f1cdd20f75d63b465dff53423aa1bbed0da5db285"
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
