class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.88.tar.gz"
  sha256 "284fee10d3faf8a834084fcfd025f704e9574fa315f3840ed4f1b506570e8b3d"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ab6811116c84a1cefdd00e5c0e50846fc004bcdaa82dcf6000518a267b65c18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efb4ab98e100e75f40ac4e072cfe6e747c86466f0e72ed74ace04b8c98f78735"
    sha256 cellar: :any_skip_relocation, monterey:       "599baaf5561fd2e35ed7fb60d9ae5f039db1fd811d2bf810d063e99d94a9a2a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "49b29020d927cb081561d1ad0771447b69036d44cff1b1510cb9b03772ac4252"
    sha256 cellar: :any_skip_relocation, catalina:       "e620c2ca1358adb275a64c0d5221f4a55e5d5e0fdcef7f0667b3434e2c2251d9"
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
