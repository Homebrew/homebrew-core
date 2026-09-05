class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/refs/tags/15.2.0.tar.gz"
  sha256 "7605249d3eb0d5f170e3414498e3344e26b1e7a147aec518b57090b80036a562"
  license "Unlicense"
  compatibility_version 1
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "7829e262f0ebbb51c4744b343bf801a5107479fe08c6d6f61f4d909748cba337"
    sha256 cellar: :any, arm64_sequoia: "2754dac3a512be2007dde3a8a481f1753ea9b0e22041a1a32b544daed966981b"
    sha256 cellar: :any, arm64_sonoma:  "8e485dfa978673c6ada6f83ca39f5f15f8b7444b0cdbe8814cd3d3d7bd83afa0"
    sha256 cellar: :any, sonoma:        "9dd76bad725daf9ad1d4c983419e79ec92aefdae0cc9c92d465b424c8aea4808"
    sha256 cellar: :any, arm64_linux:   "d3659fe11edcb52b93ce3510428435991fcb479c854d0b66bd14a2ffc7ef956a"
    sha256 cellar: :any, x86_64_linux:  "b92a80402edd4e6fa17e9eb580d20e941c60787510c4ce2716fa53d2c6d4c432"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", "--offline", *std_cargo_args(features: "pcre2")

    generate_completions_from_executable(bin/"rg", "--generate", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"rg", "Hello World!", testpath
  end
end
