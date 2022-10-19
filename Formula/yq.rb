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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9052afab859bef70da78496eb869efc06779e31422e4a1b798eab21afc49cb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d55705674756450be76c5b91c5786f7244c6f06be37aec3c129f2dfa1f66e56"
    sha256 cellar: :any_skip_relocation, monterey:       "2b0e5ca68456bb5e86a5db0070a4136eeb992f5956d9e286c3611fec4edf75a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5347e391b35cb31f5e8a2eb5d3b99d781c7a127e7b800df215fb8e1dc10808ef"
    sha256 cellar: :any_skip_relocation, catalina:       "66308332d53daa74ebfaf93d51bab74792a03c84e23163568dacdf9eccb39745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceb7a611dfd93659ddd48b80708be6300d062670fb90c87fb6e7a2f0602e94e6"
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
