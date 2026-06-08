class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.69.1.tar.gz"
  sha256 "171472b3286657378c6854d37cc6e6124ded4092303e01bb2b99b65c2d843f01"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4acc85f5e36cf9d918207f6d35af6bd4f5a6359de95822c16afa8f8be3dcc3e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f498630dc7804efc8683f9d5a9f2f6d6b0b3bf5eec7e750f6585495b54a469a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61dbce0ab5094b7ef0fbcd9c307f0bb769e50059b5b122c4e80747767a881673"
    sha256 cellar: :any_skip_relocation, sonoma:        "98a300c6cf89fd56f848c4e3ea20c5f2f6338a435cc08ca66cfa41ce14fccbc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ad0d91b570a48e841549ac04bb952f3d9897930114adaec78251a485d4efe4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db88943d4e3f0e75586addad9017f5629ffd25799fc2a8169f89edcfc53f09b5"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "btrfs-progs" => :build
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[-s -w -X github.com/werf/werf/v2/pkg/werf.Version=#{version}]
    tags = %w[dfrunsecurity dfrunnetwork dfrunmount dfssh containers_image_openpgp]
    if OS.linux?
      ldflags += %w[-linkmode external -extldflags=-static]
      tags += %w[osusergo exclude_graphdriver_devicemapper netgo no_devmapper static_build]
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
