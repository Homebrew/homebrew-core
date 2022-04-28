class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.93.tar.gz"
  sha256 "6966ad5696d3349a2c92d1c1a89c2de6ccb478826e167a1eabd54b47aeba3b49"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60242220044b0d684c9350ae4f113b0749752b6b6d19c10a9356e688f20eb131"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a94aa3d83b5d2070bb977d17a5ae210f8c9d4213ae9ae9c733839815f810ae39"
    sha256 cellar: :any_skip_relocation, monterey:       "953f5a71557e5792d2e48364b8bfc76636a6d3266631588ed4b0c9676ed5f12b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a49ff1c7e4a16736003b890e1adaefc244c4e9b1c17a1c5613423745ef0b48ec"
    sha256 cellar: :any_skip_relocation, catalina:       "b392e427a0712f4ee3c62ceb44f68dd325c3c0983caeab5ea5fc69ec934becf9"
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
