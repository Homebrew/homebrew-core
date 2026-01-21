class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.57.1.tar.gz"
  sha256 "04c3e016ce91232fcda7ec00be66a63c6f29ac01e9528d4d0e6267dde0e4634c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7f091a94c05c06c22beebd2e069d5c45c241b78b11a285caad7b6a7a5f753b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6a778b4a3ecf0d26c3acbae78a007045cb56eab8f2da32e3181e3453ee688ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ee3bafa82c3927618d31c39f11da056604920e5937620476346376a2dcb6ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "11037b0c34dfd97eac6638718b51d0c46be852b07045e8b37efa9c583cdd7531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6227d6717d1a7722bc78e54330d8a8f64fd342ac622060b5d7cbe7a13916a0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "455ea8b47601d26cab8650fd12d0fd930ec45e6fe3ebdb2700a4825e5be87ec4"
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
