class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.163.tar.gz"
  sha256 "cd2c5b45009a6c26c7c77faa4e6005ce140c24e921860b4856430c22d978f5de"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "409eabc8030efbd75153be907aec83d0ddc735b52540726b102ea8ff118f67b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f463a8b09f7f6922b2521ea28e99df4bb25ed86e7dd5afa79d77dd50fd897733"
    sha256 cellar: :any_skip_relocation, monterey:       "98da3c0735525602da616a4c509b56aa7eebfbc39fa50b1ac9b18dc8fa172766"
    sha256 cellar: :any_skip_relocation, big_sur:        "41bdfae00993ca51e749cc618fc129d52214aa0fb878376f24f1284c0a52e74a"
    sha256 cellar: :any_skip_relocation, catalina:       "2a218d28b48263ddf8b96558c4a5d234c93429be4ea52997592bde423f218f3a"
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
