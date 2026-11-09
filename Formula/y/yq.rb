class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.54.3.tar.gz"
  sha256 "93143d49b2a3bd6cb723477f585366b29f70c636af4653191d61b49b0c47de7f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ebcabd62fd524873c22ed5b86efaed3ed60d1563f89e1896be436ecc08efec3f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ebcabd62fd524873c22ed5b86efaed3ed60d1563f89e1896be436ecc08efec3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebcabd62fd524873c22ed5b86efaed3ed60d1563f89e1896be436ecc08efec3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17dfdf5acf2fcb18b62c86f3f0092a1be6f20a14ee2bf35855c5faf21fef3850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad69a2e7efc088c8f7309ab51cfa9b3b85a79cda0e42ae97f53744d15df80c64"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args

    # Install shell completions
    generate_completions_from_executable(bin/"yq", "shell-completion")

    # Install man pages
    system "./scripts/generate-man-page-md.sh"
    system "./scripts/generate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}/yq eval .key -", "key: cat", 0).chomp
  end
end
