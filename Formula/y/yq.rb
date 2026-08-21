class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.53.6.tar.gz"
  sha256 "132a28a669526f99dba52486ac80de3bdafdf9a1a52a0c6bd6045301aca0cd25"
  license "MIT"
  compatibility_version 1
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90e485ba0cc1868a3851c2597345ce52ed111e0f6bdf3f18829e42307d508196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90e485ba0cc1868a3851c2597345ce52ed111e0f6bdf3f18829e42307d508196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90e485ba0cc1868a3851c2597345ce52ed111e0f6bdf3f18829e42307d508196"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2e0cbfcd8b94ca1c2276c3f2e3c086b2a425e2dbdfce24860a36554bf73b74f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81289a0cb4c64c95e976ac557aa95b40096f30480d8177423f166ff695488504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80728595b730e247128a9cfa3919b8aa03cd8c32c38690fe3275ccaa6ba3312b"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

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
