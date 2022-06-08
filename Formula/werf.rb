class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.113.tar.gz"
  sha256 "ee5d2dc6baeda01b3df8b74bfaa2ee591eb84e269edbcb862ce14876429a0133"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fc057008f6027f8d8ff34a6e921a3d9969412baeb5513a2c1000c1e4319167c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de6c72e8730619bcfaba1a71a19721c2604dc864571f4fb8863c1e5d79e591ba"
    sha256 cellar: :any_skip_relocation, monterey:       "0d9e7a6d20517baf659e17151b2a331abf9e06d1d15e0e0a413aa20e1eb40780"
    sha256 cellar: :any_skip_relocation, big_sur:        "afbe09e5cee13b7eba65a08967fd304f77fa14762d888da884bd18392a2c9ff1"
    sha256 cellar: :any_skip_relocation, catalina:       "46bd2a2e1bcbac10967c6b457c61dcdae4b6a9095876843ffc17ea898ef5b377"
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
