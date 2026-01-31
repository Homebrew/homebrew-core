class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.52.2.tar.gz"
  sha256 "598ad3719f6b8a199f374baf7a32e9ff527300e56816f4652cd3640c230bf79b"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb55881aed2530ba835ad8ca63189f6dfe125a62c547b70d3b6b797bebe23414"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb55881aed2530ba835ad8ca63189f6dfe125a62c547b70d3b6b797bebe23414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb55881aed2530ba835ad8ca63189f6dfe125a62c547b70d3b6b797bebe23414"
    sha256 cellar: :any_skip_relocation, sonoma:        "916dfa8c44b013075a8fb6fe5fa9e7f0808418d7607162ac4f641a3e45af33ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "341d4cf27da34a915dadfb4666d5bb5b31e3a0bbcda5ca747b66ad6982c4e077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d1377d489321086718f119b73ed76395f85656f924b722db27783c4707521ab"
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
