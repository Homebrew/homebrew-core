class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.6.2.tar.gz"
  sha256 "767b6413738479c1f8446689ff6963a1db552bab6c7e27309be115146baf36b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c762efa35553565f258fafe92c104168139d8e027c7730c5a1260df26ae98c9f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e48faa2a839dd51abf563f268f8ca9d7ed8ee88d570312de1d25b2a229e39ca5"
    sha256 cellar: :any_skip_relocation, catalina:      "e5d4585a172a1c6d5e40e3b828eac7cabb8d99107cc4cc382d8a3f177d3ff7c6"
    sha256 cellar: :any_skip_relocation, mojave:        "d4a2f9a41c12e53c076080d36f35db2250baf179cadd2c602a98efc90610de46"
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
