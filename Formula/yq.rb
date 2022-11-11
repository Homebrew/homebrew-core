class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.1.tar.gz"
  sha256 "bffd28abbfd1037a9f1424bfa38276d7917c4ebfaee88d88ac117223c3c22291"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2734260d5e2ea012ee7e3e8f7deae2ccd0b0f73397079a930caf9bfe01526f8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cf0aa8956045f8167afbdde9e238e9cf99dd2c8f7fe6717c5419924d71336d0"
    sha256 cellar: :any_skip_relocation, monterey:       "ddff1b2eeace217a821837aa0fa34bd186151a573d399f896c4c8fd4f039f39e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e44ee64c4e9942fe9f552f89f9fc48342acddebc92c0c24b6df3bbf657ad4c1b"
    sha256 cellar: :any_skip_relocation, catalina:       "26cd627c49747be817d25fb1dd8f2f149948e4a09d7970b2bd3c5737700dcd9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7648db50599099a676113441f666bb0a4332a2ec35635924cad70114c14cab19"
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
