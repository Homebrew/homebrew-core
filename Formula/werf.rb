class Werf < Formula
  desc "Consistent delivery tool for Kubernetes"
  homepage "https://werf.io/"
  url "https://github.com/werf/werf/archive/refs/tags/v1.2.90.tar.gz"
  sha256 "b6b93075be1117449a69ff6e41b1b89bba723e5aacb6c213dc602e83423e9609"
  license "Apache-2.0"
  head "https://github.com/werf/werf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "773f4ed73e7b35a811e00d515cc1134269c619c40afb0fbe8003ca1919731241"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fe0955e5bf60ebe4e1893e76938462bbd0839a08ebfdba99507d18dab198036"
    sha256 cellar: :any_skip_relocation, monterey:       "68832b822089fb94220239f5994fb4658045b2d0951a6769f04adb8b903babf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "ada06998bba1e861ef68bb18352272607fd650f4d1914d416aced31921382243"
    sha256 cellar: :any_skip_relocation, catalina:       "c12cbff11a1ceb11fc2936e059ff7111add4b18016851e12ed60c83d4aab7f5d"
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
