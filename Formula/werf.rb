class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.112.tar.gz"
  sha256 "7b30ebb6ffa0011dc6c3ee37231d2a396c9249ef70fd754a3654b86bbda06bee"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd1daa112c6c08f1de29e9a61d178783b3c7bc35625de26ed407e76e8a610de0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ef8326ea2d8d1f227c726c99ddf34f571e826a0396e829dae0f64cd262d7ebc"
    sha256 cellar: :any_skip_relocation, monterey:       "4acceebb2fa284b6f64d1e532c8d11fecd66bb5f2341d0befe92ea15924b8814"
    sha256 cellar: :any_skip_relocation, big_sur:        "d26d2669eda61d1c7b44e599aa29b4f5ddb39d4beeb0363343389a7ef44260ba"
    sha256 cellar: :any_skip_relocation, catalina:       "019c990f373595f8ba763177f142523a9a6089d8f2125d417704a060b4922957"
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
