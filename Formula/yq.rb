class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.28.2.tar.gz"
  sha256 "91826a7f6cd7827e2bac69247d6633784e566b3007b5dc7b7b839144676282a7"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77db41ada753916c972cb98878cbd861edd6b7e7b9cc3aa27071c4c3fad41c04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2408c99657994ad9f39a2a160e9b439a4c03b7a891715311b8bcc70da7d5bd78"
    sha256 cellar: :any_skip_relocation, monterey:       "8368548ef1da00ec6969e339657f1d66e898e6c363bc28a4535e11c51af8153c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a007a2387ae2145dcfd868af872799edfc381cd61825af95c154e8e1687b19fd"
    sha256 cellar: :any_skip_relocation, catalina:       "9abf99f71cc7f712906dcfa8b12d20e48b6b7cc6d0605a6a357e37ffae42067c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e46679680b2132a6082e3397653a0d5d9996840f8361dffdaf423edd6223302"
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
