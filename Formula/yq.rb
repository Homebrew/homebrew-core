class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.11.1.tar.gz"
  sha256 "0a4cb1e93114334ccbbffd468f29b27d0fae4857865ae91c570c06ef94a9bd33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7a8bc1035d062e8f04cdad0902cad4471ab4e75bb333e56803132b5bc2b7fb59"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0d860c74c7b7987a79bbbc6f9ab27244853876c03080f14558b347336cafda8"
    sha256 cellar: :any_skip_relocation, catalina:      "c896d1c8fff67fedd85ad04ae364a65c955a2d2744bad53245646b6f12a6ba9f"
    sha256 cellar: :any_skip_relocation, mojave:        "fa84df4c71ba70be06a3de6529a7bb174451821097cbf991e6de2d7648d01ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a90cc97e4db449e85da31632edebc122d1cebc4f5d4b79bcc49f7b96b3bd17"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "fish")
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
