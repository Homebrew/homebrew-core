class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.24.2.tar.gz"
  sha256 "f85a01a3ed50c356d44e974224cf2be48039c73be65e9c8fe50d780fafa40f6d"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "154c022e420df65b68ceab74f46627bf65c45fab5d8af7e7a9e1a9cbb91a6692"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3fabbb84cdf280d7228bbf4c0bbafe73e95fd4f80edfe4ebed9212d5462ea4a"
    sha256 cellar: :any_skip_relocation, monterey:       "9fea029680867004647c6e320064db2b63bad774b89df20209e00831ac3d7092"
    sha256 cellar: :any_skip_relocation, big_sur:        "70e18418c3b646cd77a004d5edc47c423f83e6f02e2ca0fce9d7f5cf76a129a7"
    sha256 cellar: :any_skip_relocation, catalina:       "9c6254d8abc1fd0e871ba80ff396573bcc3237595113222365f1cf045039619c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ae28f71bdad8328e0376bffea071d8532df8df650dc58f0cd63286fc481fec9"
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
