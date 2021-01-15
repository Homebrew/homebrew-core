class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.4.0.tar.gz"
  sha256 "bd87dad46efbe333d0ed2da0b142e429833259d02d6310d97c95704ea0430a83"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "485e947621956f5efe9e1f929471ed7e95c0ec8faa0c5901070df833ce8bf504" => :big_sur
    sha256 "cc349b12574f28b000ace4020cb56d2b8e94515ffd4036a46a9ff4b4bfdfd9a7" => :arm64_big_sur
    sha256 "934d963bbfcba36a410e27ef937bd4ffbe666bbf3de6f852bbb094d1e61ac26c" => :catalina
    sha256 "ef64f0bdb58087f4546b682979c72260ac6a4d51b5788ea0d6fa47462c8da15d" => :mojave
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
