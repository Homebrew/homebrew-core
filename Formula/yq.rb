class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.6.2.tar.gz"
  sha256 "3edee5bae40afdf8869803c6f81eb15adbaaf373ba27e4907d6dd5dceebaf65c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f773cde6d263edf0631b36fd79d0fac2620ee53534a47204a5cda535e0d93bdb"
    sha256 cellar: :any_skip_relocation, big_sur:       "2733536f128283437f2f5633161d46153d20177ed76cbc1e66c8ac96921fe179"
    sha256 cellar: :any_skip_relocation, catalina:      "1bb25287643a3e41cfdabc2dc3815a37c3f0de829e9d60008ab05e6fae41a5b4"
    sha256 cellar: :any_skip_relocation, mojave:        "b37869df2df402120d54e605b1e7103fa64b7a5e42ba15bced8696f7dcc20c77"
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
