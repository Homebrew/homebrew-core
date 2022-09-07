class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.171.tar.gz"
  sha256 "d5e26f151ada7f49fe72153676e39f13ba1911fa4bc99e2ef67d37ebd6d5a4d4"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c2bcba44000394e0869153080d443fa080a3dd87640470f64ff2447a1c2198"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f8d17f924123b85a7c4238f5708b654f42a87c97973eca0e53ffc6333e83615"
    sha256 cellar: :any_skip_relocation, monterey:       "887ab543a313943f6220ffe6ea7ec5c0b1c31d62c654360a057186537db6a0ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f3dc7ae0134ef77913979314998cb02baa65a67b03fad91af960c4942b67fc"
    sha256 cellar: :any_skip_relocation, catalina:       "be1185cc3ddef0f5c2cfee2d599637cf5f677e8394b194f3a11b7f5857f0485e"
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
