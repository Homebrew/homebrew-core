class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.100.tar.gz"
  sha256 "21e08c3c9c78563da269cf060626529a46e1981bca374ae7b367bcad24eac0ac"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fd56ef8bd814a00527076386708ef6c7436b799e940ec57295f6c18480f6fde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "44d9b75286b3193eedb6944b942c7c8e64a4a2969ae375f10f32527b6c0f7431"
    sha256 cellar: :any_skip_relocation, monterey:       "cac6ca7e0b893cec2d0f0195739a6ab13144e3801dbe19e570b44378db647923"
    sha256 cellar: :any_skip_relocation, big_sur:        "faf782227bb70922904a3fe1b05625df89afcc046795d5da0680e6767ace5fe1"
    sha256 cellar: :any_skip_relocation, catalina:       "7d3261c46e8c635f7f91415374e639dd3d48d3682b85afdeff51fec00dde8314"
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
