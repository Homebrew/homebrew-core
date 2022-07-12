class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.123.tar.gz"
  sha256 "357b8fa60e1fe306ea856f116b17e658206fa8e4a497f68e93841c30771c1cfa"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b747b6db92301520f1974b983ef30cba7a4b94d6ea63bef4b1f5b020fee3f69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b2ef368fa964aa8c566e8553991056dbef021d1933a751114eaefcab54a2809"
    sha256 cellar: :any_skip_relocation, monterey:       "a3f795d12e6d0fbb7184390cbbee7fc9ff1111aaf76abc665e61d04ce28116d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cb44c4b39a49cfb678c76dd1be67d73c108dcd3481cf619503c689a4f3c88d9"
    sha256 cellar: :any_skip_relocation, catalina:       "92b26550dc0deacaa99b810827271599b6fbf30800dbc9284df11df80b2ea671"
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
