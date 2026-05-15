class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/refs/tags/v4.53.2.tar.gz"
  sha256 "1bc19bb8b1029148afa3465a9383f6dcccb1ecce28a0af1d81f07c93396ce37d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d17c2839ee1777042fee74ea12ae4b208ad185b7568736848056fca2c280ae10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d17c2839ee1777042fee74ea12ae4b208ad185b7568736848056fca2c280ae10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d17c2839ee1777042fee74ea12ae4b208ad185b7568736848056fca2c280ae10"
    sha256 cellar: :any_skip_relocation, sonoma:        "f286c6fe05ab3414f9698d81d59d36209980c63b3937e2e4e9437981e1fec8f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb220286c54f661e9779d91eff29f46055ff544995b8beffacd7e6486df5fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c30770b766c4be4264aaab9e3d901451cb8465d6e34cd42480b3088446ea1dd"
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
