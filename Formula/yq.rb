class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.27.5.tar.gz"
  sha256 "0b9ed8759c53534978a661786845eb3c6ec425aee15bab4742d1bead73e28150"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f4249dfc3623c27b2f515339f9fac7af675760f81d917b1031d3aa504ac34fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c28758f966a699895fd68bf8b019eead29988868f650823c536f490a0f68c088"
    sha256 cellar: :any_skip_relocation, monterey:       "9f021fcd3e4b71e21eca5b4f9630c7b33986d3bf57eefac9587e3bec6571e802"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc3d19e10936ba9372b5c9039705e46fa89816780665ca938643f99c857ffde7"
    sha256 cellar: :any_skip_relocation, catalina:       "174f6541dd95df5f67dc261baab96759ed359039d980083a07755a64bdc65559"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3053fbefa2e6d4b8c5eee94856cf2e1307b35d88f70d05d95a034141679a8fb2"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

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
