class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.91.tar.gz"
  sha256 "98c360233586849e8a6dd6798792548ec091de55646dc36153c099edb4794cd2"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "819a4adefcd0f48e70d94b99e9f3bdc2638106105f328c124525975fc8aac595"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acbf3f8ca41d61731b14a07eeaa1c08d3962432d7a7dd96d7bb3574fad099a21"
    sha256 cellar: :any_skip_relocation, monterey:       "de7bb39d9c19e282ed8b6d57077f704cce9bddcc375322af6188fb16dd8715ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "666dd328f65b2232ada7b7353a472e95d95caaa2e33165161836d973a62f0af5"
    sha256 cellar: :any_skip_relocation, catalina:       "2d68be03687f66ced3dd0225b1eed897c4363eee5afc5f1dde0e00f603ee1a4e"
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
