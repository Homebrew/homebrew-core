class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.30.5.tar.gz"
  sha256 "54706926e44ca8f28c74c0165c4746f372daafd4db885b709fdaf5e8f2e4502c"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f7e5b9f53dec6fb6d421ad7edf52836bfcdb5755239d0890830523beb328f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d99e13505fb6240fea146fcfd1e187d5da595a6eabdc77a7eb9485b8d728425"
    sha256 cellar: :any_skip_relocation, ventura:        "5c68e32a50f8f692c70d94d9e436b0043615309f93ceaff1e0575bc1c8ca9430"
    sha256 cellar: :any_skip_relocation, monterey:       "e04e8303bbd5f2bd7a910e0e7034950db548f817c5d0b85272e607eeb80bdf04"
    sha256 cellar: :any_skip_relocation, big_sur:        "692c809cf647f5737c15eb0fd0e9e8f4b51b443ad67861e6f3f321c95a93a757"
    sha256 cellar: :any_skip_relocation, catalina:       "bca15d2e51a21aa22fa8ebcd2e02755a29969c00ecb9e69e70fb30adbc728bb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a80cd92a75388a83b8a5e8e6c3c93c6a8f49f57fa1abeecc9d565015c0cf2ba"
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
