class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.137.tar.gz"
  sha256 "9091c208ea8c4355089743b94b3e8894db244b6d502f250f24daeb54f8749cfd"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41cd71aacfbd91661576d995ffde89cf55e4e33dc370a8132acfe4235f4d51d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bc13b0d14dc0162a47d2ee719a70dafd034b0bdfb569ad1ad34aade5347d037"
    sha256 cellar: :any_skip_relocation, monterey:       "35ee2159e0e346603769a9a4767af8648e15fe89e865cd8f31793bf88a97bd38"
    sha256 cellar: :any_skip_relocation, big_sur:        "d95b37ee5cd9ab2f45fa8e4b2134e56d0ca64d38418f28ce8b38156816a241f3"
    sha256 cellar: :any_skip_relocation, catalina:       "e5b0d6bacdaaf16c6a5538beba91b9889a518cd26e505117ae49bd3036dd401d"
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
