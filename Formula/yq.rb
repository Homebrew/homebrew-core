class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.20.2.tar.gz"
  sha256 "031c63dd98e564b9a74b842ffe8ae929085f1486f59a27d4feb7e118f40c8a1e"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e257499ccc9fe1ee6d43640b3cca572bec0c8a4e27adb02dac0247613b12ce1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "421aea3cecc5ac16f45a428008c805fa96ee13412cc1a17fca5f377eeacce874"
    sha256 cellar: :any_skip_relocation, monterey:       "15558cc833c981d8b120146792aedff9f6b4ebbf214f81248ef722b62b676502"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b1b98ba4aa6dc6d5d65f157aebf1e6d68eafeb97796e08c19d16bca5b255c11"
    sha256 cellar: :any_skip_relocation, catalina:       "b3c913fad8a26e26347fe03d55264fe5d6e899e67eabaa1d76acacef58ee417c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea3dd3a7c6403b1e44536906864d92dbb0b36e949f13a663055fc9d823888e5f"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    (bash_completion/"yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "bash")
    (zsh_completion/"_yq").write Utils.safe_popen_read(bin/"yq", "shell-completion", "zsh")
    (fish_completion/"yq.fish").write Utils.safe_popen_read(bin/"yq", "shell-completion", "fish")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval \".key\" -", "key: cat", 0).chomp
  end
end
