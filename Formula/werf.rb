class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.147.tar.gz"
  sha256 "fc38d6afc19c4b80fb6a2df8c47323698ae154e9801da2a8d67743c49186ce52"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d9317975282ea6cc262cfb9066dfec04c0fcce79f7d868a342eac52938f0d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71da1adef435d81008fca8ff25e3ca4d42fcfaf7894dd03b57dd9e15f84f2a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "27e4843390f951d2cb796dba8772def4f473cbb9103b447aa338f35684b2807b"
    sha256 cellar: :any_skip_relocation, big_sur:        "055867faa2503af9b2bc500f4f01abeb32a19a1afd9d53d8901cc056e67bfccc"
    sha256 cellar: :any_skip_relocation, catalina:       "f8f2a8a7a0d6287c79d6514506b441a2f6803b22299612c11a831ed54d11db28"
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
