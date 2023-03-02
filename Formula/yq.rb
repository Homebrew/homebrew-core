class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.31.2.tar.gz"
  sha256 "82d5ef2ab01bc5065e7efe671d92fb82e53f41dc67b04cab6c3b22fd144bd009"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e84b57b8bdacea3fe2d6ca4723bd64ffcbfc2dc8b63c0118091e8b6897d7927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8df2a9e9e86a52235e8171afd4b93dbcdf326194e9871b64135a48fc54fc68e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5918cd7d5436f703f66d32a9e5a93f23ef7bfb8de10eae8114ad59ce65ccdec"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0a49934dcf437c6e97f0c8f7915fb05d0b0ad5022b13b86572919da05d6aac"
    sha256 cellar: :any_skip_relocation, monterey:       "62506906195caee1089e032cf3b48fb30ff45115e588308d123d0f851474bc6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "892605774ebcac5b73ab749cdc51ede3f1af2f2e5a0a7479f61875008426f80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5453760f155dffe737b58a1dbd14a61fbb27c024920d24d390bc0c7574221f"
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
