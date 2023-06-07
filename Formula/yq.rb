class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/v4.34.1.tar.gz"
  sha256 "69ff6f8bbb5f9eff5ccb537597740d24200db201b2709e442ae5effdbcb8ff9d"
  license "MIT"
  head "https://github.com/mikefarah/yq.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c74b4657d201aa4393249403004097a2cdf16f33b940f8c67d34828892f700c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c74b4657d201aa4393249403004097a2cdf16f33b940f8c67d34828892f700c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c74b4657d201aa4393249403004097a2cdf16f33b940f8c67d34828892f700c"
    sha256 cellar: :any_skip_relocation, ventura:        "b14dc0e789d95dc8e91a87b52c2b397169312c59d840b923891ab32af5bc3258"
    sha256 cellar: :any_skip_relocation, monterey:       "b14dc0e789d95dc8e91a87b52c2b397169312c59d840b923891ab32af5bc3258"
    sha256 cellar: :any_skip_relocation, big_sur:        "b14dc0e789d95dc8e91a87b52c2b397169312c59d840b923891ab32af5bc3258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ed1e54556bde4148f7febecb8bf790df1db925640e5026834e940e46d59f4bd"
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
