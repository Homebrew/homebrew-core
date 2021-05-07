class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.16.0.tar.gz"
  sha256 "c71af2141f8793b5be20e6068b6acc5c4ea58dffe0d5bb5a5973359d094ebf9b"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8614847400f9595448f2c4f6bfd10cd2f8843f9c8cb1aedc4aa1f4583b5fe4bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd44a324e930133a7715fc1f40da67ad31dc57d13285ec98df9eca58547eab6f"
    sha256 cellar: :any_skip_relocation, catalina:      "6e9476bc80077817a88550ce4f9028c9b9cd259d1e89fa3baf938e90144ae201"
    sha256 cellar: :any_skip_relocation, mojave:        "aa5241c068a8645767324a851dda242d9fba68c042730a4e78ee26fab60598b6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/stern/stern/cmd.version=#{version}", *std_go_args

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
