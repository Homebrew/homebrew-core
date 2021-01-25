class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.4.1.tar.gz"
  sha256 "bdd078847a74245e4c09af3dc31cdb482588398f342a8db4c019115a8495ebad"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b20bf737ae3f711617e28bc564f737f27f5c78e5196f9f02ff83948507356d33" => :big_sur
    sha256 "c6bc69e6856eb3aa19658a1e68817be867564859f0d3fc505980756b3cb6130d" => :arm64_big_sur
    sha256 "6f1ccfbdde2fa5d4083157d8cc1a81d0664970203424c62b2036a1a27c9c5191" => :catalina
    sha256 "46246d5f403718157d1b32878fe5325c80c20be93b37b1d12b594bbdfd9d9b03" => :mojave
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
