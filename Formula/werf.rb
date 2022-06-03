class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.109.tar.gz"
  sha256 "ac28f805d2face4f37a4e568d0fb61715d5e4f58b6ee2e06ea2e5cf5571d556c"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f440e2642ae6272f731ed88e23524efde568d1f37ee7a3a3d77e08f5a6326db3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df22328892e2730c23bca3b62e05704d725347a5875c11b2b62855f839bb5ec6"
    sha256 cellar: :any_skip_relocation, monterey:       "142671ce1c0f242352afe5e766eb2923f9d5bcdd53a625f7876193d9f22b8184"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f574d0a4225f26920060b621ee2f8705cb5cff5b83303ed970ece20ea5a9dfa"
    sha256 cellar: :any_skip_relocation, catalina:       "53f78076401f626035e7669e2ad2a88f18be6fc0a98686cb6fd59e8f4fc867ed"
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
