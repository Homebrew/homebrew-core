class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.48.2.tar.gz"
  sha256 "af464e5c227ad3894628de65db2996db0e4716a16388eaf08bfa73e93ad0604e"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30522e1242c8941f620609718229e9ca10bfa07a141bb153cd4a8d8495d75a25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30522e1242c8941f620609718229e9ca10bfa07a141bb153cd4a8d8495d75a25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30522e1242c8941f620609718229e9ca10bfa07a141bb153cd4a8d8495d75a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "920618b23f19c011988b915e9ce72bc236b9198d1606d04cc3b89eda20231c78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51ea0741c9e0946b3fafb8bda01aa0ced4e1c6ee2b12ca4490e1ff824dd3f261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca70df59deafa02442b1fea07218df09930e5ae6f942308513b389a060d2d1f6"
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
