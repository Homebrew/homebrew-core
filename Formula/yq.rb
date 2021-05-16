class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.9.1.tar.gz"
  sha256 "7a15a78b9b6248f7207db54073fd685ca2966cdd9a4fd6601a9db446900b068e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "961d50e0a3eb4c139b7288166ed6ac82ac5a3ba044835e8d8e0e21faf7e798c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2852ab88bf59b5699d523eaf018f4998f95683a73daf0792d095d358a408319"
    sha256 cellar: :any_skip_relocation, catalina:      "c956e609e1aee48cf592f9a72fe47b11a223cf111f01d7e669e281dc57c0d7ef"
    sha256 cellar: :any_skip_relocation, mojave:        "f56218195c4a0bcdf2501b8005a842f5d09d22440798b6690bae4f73f80b0c0a"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args

    (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "fish")
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
