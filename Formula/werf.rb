class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.105.tar.gz"
  sha256 "3e7bc64d5e0e4589d72e3506927d0ba2b640e67fef04593d08ca4ebb1733c2ea"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05f2eb825a07f74fafd13eccb7724606df5723ad58ac2d94374defd4bf72b8cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49763607201cd93cac9cf678fef79361870f71407499bd4ea8172d62da6ea88f"
    sha256 cellar: :any_skip_relocation, monterey:       "9ff1c87e38aef5dc8dadf84300abb3632b6c78ddd3eb653c087623b26c2c1cb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "71c43c32349e92d498163a7a38d7cf6c82a74c16c0f9806edf001d5f99c43111"
    sha256 cellar: :any_skip_relocation, catalina:       "db98b51db7f466d8c000c4603226bd3e9c44f04f8a74b965b2051b8d06b8bdd1"
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
