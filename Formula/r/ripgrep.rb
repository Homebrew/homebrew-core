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
    sha256 cellar: :any, arm64_tahoe:   "70d2dd4c77e3095797b768a1b6c1d092a1ef6db5ba81b38b422920b7b87c9886"
    sha256 cellar: :any, arm64_sequoia: "aa54bb41d674d2872cd1586f4a71b9a712ab20dc5e80b58d464bb64462732fcc"
    sha256 cellar: :any, arm64_sonoma:  "24ec18fde1c3dee7cd9646a67b92642bb3ee3f33ee4bdabbb27e03feb742b0a7"
    sha256 cellar: :any, sonoma:        "1218ff07ff11402fc41e7cd2f52d4dc1ba50fde0568713e473c14e1cde51ef39"
    sha256 cellar: :any, arm64_linux:   "f9aaf3150f27c6ee3c67a05e6c54a1d030fd57144eb33e87b2db67784b8b5ff9"
    sha256 cellar: :any, x86_64_linux:  "1380aa0ce79e4e494201d66b55fa4301c4e23d72d70ceceb2c1c61e7613bf59f"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pcre2"

  def install
    system "cargo", "install", *std_cargo_args(features: "pcre2")

    generate_completions_from_executable(bin/"rg", "--generate", shell_parameter_format: "complete-")
    (man1/"rg.1").write Utils.safe_popen_read(bin/"rg", "--generate", "man")
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"rg", "Hello World!", testpath
  end
end
