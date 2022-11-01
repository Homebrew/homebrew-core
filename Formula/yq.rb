class Yq < Formula
  desc "Process YAML documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.29.2.tar.gz"
  sha256 "4a349c7858793463555c12df698757265a3e46d6b107adac75fabc46d9591df6"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d3900582843513cff94478709d5042021d791e1437eeab1b72615d8dd821d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2c4b27dccfdf861aca4068280cb8122d9fa249768cf0938e630959c9067eb3d"
    sha256 cellar: :any_skip_relocation, monterey:       "cfa6da890f886e37678d7fb7dd616ee59f36dbb2fb9506f107f60bb2c3ef4f77"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4b476362f2d9c23cc075beed05580aee60decbd9752e5ca95f0e223855df335"
    sha256 cellar: :any_skip_relocation, catalina:       "c4dd6e28b04052cc3b84489e13d0b608cfcb95b01ccefc3909f20a9a487e6c37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5b80bcd557180ba075242c1f67d1dfe8ce14e8c527fe030c6c8fa363ad21176"
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
