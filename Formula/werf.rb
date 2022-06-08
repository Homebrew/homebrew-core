class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.112.tar.gz"
  sha256 "7b30ebb6ffa0011dc6c3ee37231d2a396c9249ef70fd754a3654b86bbda06bee"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ddd9cead49183d388a6fb229df5b6d496429785c3b32b1ba57aed780bb7c097"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25544968012dfb479f527a5dcf5347078be697e8dcc16a1dfbe664281ca41656"
    sha256 cellar: :any_skip_relocation, monterey:       "a491e8c596b054c12e65a01e4d22ef2375ab3341b74b3f60a6a8f111df9042d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "31df9b4994e898ea72a59f4a5beeba63cebb0932911d73dd14d03926a347546e"
    sha256 cellar: :any_skip_relocation, catalina:       "dd28dad2799c4800bb523431e3dfe90e9861aece6e908ea77a2533475fb0cc39"
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
