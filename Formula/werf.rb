class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.97.tar.gz"
  sha256 "dfefe89d2b4236c607bf6605ea417cafa818611b3858c6df94e15f762ac366d3"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55227b7afa2c042fb15b4e77c7488c96bd0da88b71533a2c62a9aaccfcee39ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fd5e482c4f0d7e665e7552c33e6f6ab1504bde4acdc9fe61f1968b92b6ceb67"
    sha256 cellar: :any_skip_relocation, monterey:       "7e624c6cf7717971edae314fab2453183b62680bd4c58300c10fd89a19e25507"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e11f014e2d50c2eaf9132925e6e9805cf59acfaf74f0976e43e51a9fdd5f308"
    sha256 cellar: :any_skip_relocation, catalina:       "9ba7e7e5094e246ba4db9f90d95bfe93da5843b046375c405c2d24982d8fcc54"
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
