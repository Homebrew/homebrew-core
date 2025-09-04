class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v2.47.3.tar.gz"
  sha256 "73f2ca70b1f051ceaa246c3340752c58e327e262872ef64911198b42cc0a15af"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21d9a34f9c1985c21a3c52bb6877bde49faaf7035525f0eba1f096cf0fffdaef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "757f3b72d8d0c0a3c5577681d0fcaae6a22f5af2afe765583f8092e441e9dba3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b40399ac111dfae529056799aedcf2097b8312ccc8ba68bfa1b4bc37759f5db6"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a69602127c48d0568248e674b51abec64576a39115d511d47816eecff8aacc3"
    sha256 cellar: :any_skip_relocation, ventura:       "aa92cb1373b9d365321178eb8312cdf1b3beaf15dbd74ee8f7b1908f35871239"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a9acbe24ab2569de0806d13f24ec6270ca084e0e4c02fe4ed41771d2f62daa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e8d5fd6de161a177f7f76c64580ce7800f85489d2a93f8fcbe2f0174c386e04"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
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
