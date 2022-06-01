class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.108.tar.gz"
  sha256 "38b65e45f48993589d03363216377110b1b5d8e6f1e077198807cab7419fdb43"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad2f008a7ff48435c15cbc23acbd2d621429921a45349f9c28e538057a42b060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "184a0a38dcc0dc4c1503912f7b9b7f5e52da8dcdc3844da264fe3b23f84fe698"
    sha256 cellar: :any_skip_relocation, monterey:       "b776300b66f63ebf9b1e9d2a111c2de6cd12c8a29540aec9db2f08bac46fefbe"
    sha256 cellar: :any_skip_relocation, big_sur:        "c47fe3df3fc641b140c2ec7faebcff56d707f2e94434762006c826910b6355e6"
    sha256 cellar: :any_skip_relocation, catalina:       "f789b51bb98bcf6fd694e06a04302bab943a4e715317479e3b3e04497779ed63"
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
