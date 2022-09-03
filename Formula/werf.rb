class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.169.tar.gz"
  sha256 "7e3252ffb477b76c6b4651ff8e90d9b8af2a9b67d98f11fd76743974a32650d1"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9034c77153337843130c626caf6fd996e0c7595b2524a612da155768b86d0a18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e664d2d86cabdacea810310c690e034ef762870704590d049ff2e8ba891f498a"
    sha256 cellar: :any_skip_relocation, monterey:       "122ff6ed58c123504b525abf8ad583af40c7ce7afbf4b62a0ca7391b92edf036"
    sha256 cellar: :any_skip_relocation, big_sur:        "0df1aec92fbd97aa42cf20467dd68aab164f5e99a0e565bfd95d93a9709022e7"
    sha256 cellar: :any_skip_relocation, catalina:       "f3c71d0426def87a63efbc872019d7633e8fadfafa6b07daae5e4ab70d65e1c6"
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
