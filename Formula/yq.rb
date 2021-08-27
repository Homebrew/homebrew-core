class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.12.1.tar.gz"
  sha256 "a1cc4aef9f7a7b72eb39dd8cf0fb9d726d7c2f19ec817bead9843859649ac3f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b93e6a635956b085d17f7f6b8b14b0bcd98f5bef339d64fd4cb34abcd9d97f04"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8a585b1ad709abbf56128f3a332e75af36c975abe712fe1c5f1b40ba4db1274"
    sha256 cellar: :any_skip_relocation, catalina:      "30f2f6437945d825cf655fb3c96f3d95a4c7c1ca723de553a13bd2c7e3da87d7"
    sha256 cellar: :any_skip_relocation, mojave:        "8791cfdf687111cd18c04599b92c9e7073bbb35388b37b97f4448b9bb48284b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40d8d9c6390d889e045f74358d5b7edcb73fe3eeeb4dadaf0e0d67421f09186"
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
