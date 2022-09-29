class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.176.tar.gz"
  sha256 "ade2726020b153e7661a818b8e2335c9ee780434b677cdf27c70d77553568e6f"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "608b27316f344c66c7bb1cb09be55e4151d65fb0f944502ee41afba17b5842e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54787793ec459ba93d0d4165373da1ac821c2a8462cf06e087d61bf89df4d0d0"
    sha256 cellar: :any_skip_relocation, monterey:       "5d774ffcef722dee1f52cc1b997fb8dba4744dbf829af7bd48d352c4947e8ee0"
    sha256 cellar: :any_skip_relocation, big_sur:        "000360e0c4ee64ddfa229095194b091990e3ba324c96827b6efe633acf760e88"
    sha256 cellar: :any_skip_relocation, catalina:       "f477c8cd91425e8bc5d54d9f7cfb77f66c430b83aea468b83e946d501b460906"
  end

  depends_on "go" => :build
  # due to missing libbtrfs headers, only supports macos at the moment
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
    tags = "dfrunmount dfssh containers_image_openpgp"

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
