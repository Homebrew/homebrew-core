class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.10.9.tar.gz"
  sha256 "8ec9790612188142120af030a3e312c35bf0ea5c324432f59a00fd73a53e4384"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb468b4c23e5451513d8ebec142222a72c3fc231062dfd804afb56254dd5b0a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "059ab1156be0c82337e8b1e2d7e731483b3c1dbc6deda135201c82e07771bc0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a4d6e1c37878cb59a32f2d2dda4c779731918156aa154b98a01e939451d0edc"
    sha256 cellar: :any_skip_relocation, sonoma:        "397ea239b4cc0530fbac17eb34cd7f0268a402d6e15ccbb4250d006c9d3b5559"
    sha256 cellar: :any_skip_relocation, ventura:       "f15ee87f5b4a11d2bff74c2a69e177c1a31204f216f0f6109ef6cadd13a7fcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b18566422f3fa8ea2e430c4f86d8a04bbdd9175a365840b112eb5fe3778cdb89"
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
        -X github.com/werf/werf/v2/pkg/werf.Version=#{version}
      ]
      tags = %w[
        dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp
        osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build
      ].join(" ")
    else
      ldflags = "-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}"
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
