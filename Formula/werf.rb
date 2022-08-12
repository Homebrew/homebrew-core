class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.153.tar.gz"
  sha256 "d23d3a7c82706770503d73768448c2f84a23d447ad4e7b10d536b8a5741fc8a8"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4337b9f97e9f0b08b3f1e6a8accbb513d184e2d25937b16b77eda5b2af8435fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9e9e2a9ef5411623690b882cfaeeb6487e8a991a355616e222761e568c56563"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf768daadcd6842e2983d1a9f0f910ee099fb607c40c51fb35599cd9d07720d"
    sha256 cellar: :any_skip_relocation, big_sur:        "391a4a064882435b9e0a78e744e072942d8ea5e8f26da932008b83c0ed4e12e1"
    sha256 cellar: :any_skip_relocation, catalina:       "df72ea04fec88f3ab79f721b7046399a9dbd35f633c6918b43a8c2cfa4a270bf"
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
