class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.292.tar.gz"
  sha256 "238da369f05eaef3ef966578cf0042a7bd988e2164a929db515cb0258c891f16"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7ed2cf90ab866ff76571f27c82bf6081f8e23e7fe5368dd3639e36066c4807a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fb27e9ed51b70c232cb5621922907aa85182ab3e302d1303511d0652b5dae91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "197f143310537d9d8ea09928ecba8ed754ab541c075642a4c4479b7569d595c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "02c74830acccc4d8c08562d694d50c7f1f373ac3f2a9e89ff6aea00e454c4c98"
    sha256 cellar: :any_skip_relocation, ventura:        "f9923fb71c9563408472b5704b7b9055d9d5c58d021cfa0cc210e8d54dec7491"
    sha256 cellar: :any_skip_relocation, monterey:       "036c03920ddefc489ecff3a20ddeed2a217985fcd6accda78b10d11e32c2e4e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f1152f4cc41a00cad7732377362f67bc6ac5285b89ea7a927364d4b73f5af0"
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
