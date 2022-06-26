class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.117.tar.gz"
  sha256 "f967d527c6149c32e4cd1985d4bea68a6c5f726c01a158733900c4932a94ca23"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0da8c5df6c6f6a32af355b6b0664a09e822515455d36fda12f06a57d83b8af0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e0359ba11bb5ee00fb9b832f3ff1b4a1f4c345f97ea9561db44bd7c1ff9c900"
    sha256 cellar: :any_skip_relocation, monterey:       "4fc802dec0943cf0c47165b5c886b1348b5a39728f1386c7522b41072ec3b5bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd6407ef802977787dcf40a505b560475be87491a90bfd91521ea4167f6ec0d0"
    sha256 cellar: :any_skip_relocation, catalina:       "d3cf382749e92b97b98440d87094105fbcbabc08b1643f252361b14ee428821c"
  end

  depends_on "go" => :build
  # due to missing libbtrfs headers, only supports macos at the moment
  depends_on :macos

  def install
    ldflags = "-s -w -X github.com/werf/werf/pkg/werf.Version=#{version}"
    tags = "dfrunmount dfssh containers_image_openpgp"

    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags, "./cmd/werf"

    bash_output = Utils.safe_popen_read(bin/"werf", "completion", "bash")
    (bash_completion/"werf").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"werf", "completion", "zsh")
    (zsh_completion/"_werf").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"werf", "completion", "fish")
    (fish_completion/"werf.fish").write fish_output
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
