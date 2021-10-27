class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.13.5.tar.gz"
  sha256 "c0d637e7d7d5f370960af713e0f7e769e1b0876f71a844373d0307cbba68c4b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a37867d759db29a715ba0dae55e9885baf9bb7e7c36b2834d158512c4d65b70f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb3ded56cf2b87993ef9f2fc627e8474c49a615a98c4e2cfda9ee07c62d52357"
    sha256 cellar: :any_skip_relocation, monterey:       "9f537843e280d52f53af26faa8beb0c405441351dbae4972e5a6240d265297df"
    sha256 cellar: :any_skip_relocation, big_sur:        "8eb888640d3d492daede4c02d7e5682ff72aa34b84c16a3fae914592c5a2b4d9"
    sha256 cellar: :any_skip_relocation, catalina:       "4c102975df85e1ead50900553db90ae16a22ad22f6094a5afd1a435467cb0c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8406917ed7558422d303b33f9df0de3c5d85573298e33cbe38c65fcb45f92cc4"
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
