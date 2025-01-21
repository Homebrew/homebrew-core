class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/refs/tags/14.1.1.tar.gz"
  sha256 "4dad02a2f9c8c3c8d89434e47337aa654cb0e2aa50e806589132f186bf5c2b66"
  license "Unlicense"
  head "https://github.com/BurntSushi/ripgrep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b8bf5e73c9c9b441de067ec86ac167b071ecc2078dcb1d89d2cebbb151feab35"
    sha256 cellar: :any,                 arm64_sonoma:   "47b9c3515c866b147f0e98735cab165d6471b9f28fab1ba2c57e59c43da5c10b"
    sha256 cellar: :any,                 arm64_ventura:  "e14a94e84c028ff53c1be3b106fdeb5aca4d7c893a819e7fb967e0719b946a28"
    sha256 cellar: :any,                 arm64_monterey: "ad8dc4ab475c84e2a1e60f5b3107f52dd59e33f84a08284b19681d8b98508fd7"
    sha256 cellar: :any,                 sonoma:         "71d434eeabc2af220285b037f7264563ce9bc77a41af35eabe2213276a37ec2b"
    sha256 cellar: :any,                 ventura:        "0cdb547c696992d08c6613c40934218964f4a061b5413c4b2f013c3f0c3ed253"
    sha256 cellar: :any,                 monterey:       "2ce54302e4524ad28389aca5a16333d4193128e911de2881e6b0e953559d89cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d7cbd33b4d0ed09551e3dbc07f830d3df018c2aefbb2222a12ccfb829aae30"
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
