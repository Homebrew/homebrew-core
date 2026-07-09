class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.53.3.tar.gz"
  sha256 "fadf86d0ae3988bb40fa8aad424d0c71658493f6377285e711c7e7e313b3b238"
  license "MIT"
  compatibility_version 1
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1cb672a0cc915a1ca39f868ea107860fa18550db30d8f29bb5e76c071c14358"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1cb672a0cc915a1ca39f868ea107860fa18550db30d8f29bb5e76c071c14358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1cb672a0cc915a1ca39f868ea107860fa18550db30d8f29bb5e76c071c14358"
    sha256 cellar: :any_skip_relocation, sonoma:        "efa8cc6c35bf6733b8ef2af15e4de77fd8522d91d8bb080e0993f499391b2932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13fe63ec93608539319dd1602c60ccd6b6e03cc9e7e8490fd9dd680c06a254de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989943b8ea1203cb3eaf2857ad789ec9778510c3fb3be491ff2ad4f969873607"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    assert_equal "cat", pipe_output("#{bin}/yq eval .key -", "key: cat", 0).chomp
  end
end
