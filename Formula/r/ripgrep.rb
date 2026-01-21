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
    sha256 cellar: :any,                 arm64_tahoe:   "f4dc761b07edb8e6438b618d22f7e57252903e2f2b973e2c7aa0da518fc374b9"
    sha256 cellar: :any,                 arm64_sequoia: "0153b06af62b4b8c6ed3f2756dcc4859f74a6128a286f976740468229265cfbe"
    sha256 cellar: :any,                 arm64_sonoma:  "d9c83b35f30d48925b8c573afa83ec32b10aaca8f247bc938650a838d188c5df"
    sha256 cellar: :any,                 sonoma:        "ab382b4ae86aba1b7e6acab3bc50eb64be7bb08cf33a37a32987edb8bc6affe4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbdef955d5752e53473be06b698c45ce31682cd47d75e7c706365450bd08ff44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "349bc55db5ad4b4e8935b889d44c745ae23605c1d57d6eb639dbd5c86d573a88"
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
