class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/refs/tags/15.1.0.tar.gz"
  sha256 "046fa01a216793b8bd2750f9d68d4ad43986eb9c0d6122600f993906012972e8"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69fb4ba07c0c4376cd4a9b2ec5e5af9358c4399a67dbc5524153e62c6020ba99"
    sha256 cellar: :any,                 arm64_sequoia: "650633027b96270925635a8430f603c5e229ad577cc4c4151de4757f29c153bb"
    sha256 cellar: :any,                 arm64_sonoma:  "2465017e2af1236b0eb832646de7b989b71ba12b73f9ae66d9b41bf9385d7dfc"
    sha256 cellar: :any,                 sonoma:        "c543e16804d9e0d41cce22310153c99ddd5e05837f969401c3981d2ca5b32380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fea86c48e8651ec09be43df1bfa7a9b2700bbb12df12482e3fc628a2348fcb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a99b0650a17f70a1426d68dda6311a50ab541d3e3eb446accd9cb53e6e72cc1e"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", "--features", "pcre2", *std_cargo_args

    generate_completions_from_executable(bin/"rg", "--generate", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"rg", "Hello World!", testpath
  end
end
