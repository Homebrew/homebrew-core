class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.110.tar.gz"
  sha256 "431824d623976bbb6b5edfcefcc9510cbf6ebb07853d7ba01652d8bb42d55cdf"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e848588bfd9a86db802c7a41796f884908ae6ffe11d483c4ca23ef5f0397d84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e706dbea6ae481a0f484268571e426979f7a6e6363671168ad9a53fe8ad10d4b"
    sha256 cellar: :any_skip_relocation, monterey:       "1be4aab44ff51a07ff0170ac6831c5e7bbac91dff70fa40be8034067087f3e74"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fb1364cca6c4bfda30b0a400cd62e2a44083c32f1e5268ff6d4b9de8cd368e5"
    sha256 cellar: :any_skip_relocation, catalina:       "91d1f120f540fc269b5d1c9a6c8c307cf63850a66aa6121fbdeb8f257024af83"
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
