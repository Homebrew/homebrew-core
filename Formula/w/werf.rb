class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.63.1.tar.gz"
  sha256 "07bb49332ca2dbb995e43296a422d76b3f2473bf93003d00167cac9c4aed7807"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f209e17faed3f301e905a72e4b6b441b4f7c900fb0843134313f31850c5181c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a63d608aa8c7f991c2aea97135b0d75e277a732b02dc9719b551c2eef74d23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d37ed2d17fa9854fe841d53e49f8283ba1d3c09c9947a9b311f68e9b8bfd3af8"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ae690bea95365b17183e61195a31af1b36f886774500f366064720cd2cdcb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "654159b615a565eb04d17462383065f3af35e6eeae97678f16859266154f13a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbf855df5d38b86d656e4e9ee783e623dfaeb1b44f3538d872526414f04f2a0c"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "btrfs-progs"
    depends_on "device-mapper"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

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

    generate_completions_from_executable(bin/"werf", shell_parameter_format: :cobra)
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
      - image: result
      - image: vote
      - image: worker
    YAML

    system "git", "init"
    system "git", "add", werf_config
    system "git", "commit", "-m", "Initial commit"

    assert_equal output,
                 shell_output("#{bin}/werf config graph").lines.sort.join

    assert_match version.to_s, shell_output("#{bin}/werf version")
  end
end
