class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.35.9.tar.gz"
  sha256 "e5302c2a9cba62eeb4fc3fc4fa6cbd20a983899601ec02aa9d247b4554aa5637"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1269c9d679e1718a0ac15790b80a3a9080ca6f938b62300e1ea514639dde3ce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887cf538517c613eaa76b7462e69bb7fff882ff230dbb13b08e25e373972da9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1022eeffb9a264100dc6b93e655b81b081b9a270b3c7f09a7e84677a0d5b470"
    sha256 cellar: :any_skip_relocation, sonoma:        "8600d8ff872ce0e25e628e2921175425fda63bb2ed8df3ecbe951ba8f6de1407"
    sha256 cellar: :any_skip_relocation, ventura:       "58875ac62758db3b8f09157dcc917e715774f4ea098e86f6692bcffd6aaa2a17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88814c1101b464a564c304d9629fd94a91a002cd0902fff1649518fa43038354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bebf810ede6b95440c2d1c4e529b81c3648a8849784b2b71c99553d1a21268a"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
