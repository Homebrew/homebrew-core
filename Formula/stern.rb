class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.18.0.tar.gz"
  sha256 "86cb6458c2136936e787363587cfe3dd81fb96251ea961e7801824c3db0b4441"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1fe84c0352071e5e298b51b731bf41131933c292c073d7ef0b1819dc0643a2d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "405567683bac9931fb2d88f6a1c32928d12327b972d9ac585c9d2ebea2eec661"
    sha256 cellar: :any_skip_relocation, catalina:      "da35f1b0008de6db7de6761f576da73ddc458e66275bebab4bdc40d1179f54e4"
    sha256 cellar: :any_skip_relocation, mojave:        "a986b92863c0a8ce4fb1f3264dc06ce403ef1e7db61efcde8b9f2837effed3d4"
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
