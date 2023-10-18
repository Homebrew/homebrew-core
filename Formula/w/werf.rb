class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.266.tar.gz"
  sha256 "17eab3d5cabdca18534fc4a424cb84c55046ba436eb36187c37abd02e36e61e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3310d841fb330ce709907b81eee49666e054930ea2a0730c8bf9b52afa81fc34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "154a5a495c9f1080491a9f591967d7bba64356cf7d2cca69dfd76fee866593da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dc6e3090a03f22d61465b3b1fd67f8934a08434ec902b0188c75785e526609b"
    sha256 cellar: :any_skip_relocation, sonoma:         "672b9b1ae95c95fbe1e83e7266c23caa14558a7f4bc03b2d534fec2a79598fa0"
    sha256 cellar: :any_skip_relocation, ventura:        "7aff08031e1e5e046a010acfd68413b8a50b004dada18dd065f64ea084090057"
    sha256 cellar: :any_skip_relocation, monterey:       "52667e1a0f042343ef0f24bf536dc3c20d3f7cc70befdb10f2e073114c163adb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a12d0a6c02ea05d2f30845c0bcc5602562286209517b2a649f921dc143f84d38"
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
