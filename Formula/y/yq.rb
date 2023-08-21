class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.35.1.tar.gz"
  sha256 "b3e079169529ec6b42925d0802c22d86f1ef6e1458dce67eae5a1d6db56cb8c3"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0be75603207f48c20c318d72be1589beea10452ac2bc5296018499d478b3889"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0be75603207f48c20c318d72be1589beea10452ac2bc5296018499d478b3889"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0be75603207f48c20c318d72be1589beea10452ac2bc5296018499d478b3889"
    sha256 cellar: :any_skip_relocation, ventura:        "5c01401fcc1b7f7d71ca34b0dcbca1d984b2fcae4de189304f272dfcd59e28ca"
    sha256 cellar: :any_skip_relocation, monterey:       "5c01401fcc1b7f7d71ca34b0dcbca1d984b2fcae4de189304f272dfcd59e28ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c01401fcc1b7f7d71ca34b0dcbca1d984b2fcae4de189304f272dfcd59e28ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f35eb5832f15c1627dade905689d4280ec142c50087bbe4e7c70de940441df"
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
