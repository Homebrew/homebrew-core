class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.102.1.tar.gz"
  sha256 "313bf633c5946cb3ae6a1b7ee7602a803d3c8eba84a7ba57bc73487d4b218545"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f39dcc1ebcd6f486751239802c3df3590e3d06579c9a96a69d18d890409631c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4eea40ac73d72ad1fffeb9ab0296725fb4138b01b3597a053705a048e322166"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfe29340325baed85e81aa8d106ac8845b1e9ec02a5652bcc06895a5150d1961"
    sha256 cellar: :any_skip_relocation, ventura:        "91ce61481873e809a6fa93f7964e15a9ea390412ed147bfbe3994174235808ab"
    sha256 cellar: :any_skip_relocation, monterey:       "4a3ea2504e89101474d4efa4a2f6a10490310905f3a0b50c44fcd00f21f061dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "57d81533291f91cf2707ae7f3588838d5e8933fc97100ea3222a44d76392bdf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd574ebe896bdb40c9ed9b602f170128a5b9d64e89d45bb98a0ec04423c8acdb"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,luau,feature_capable"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,
      second header,NULL,,,,,,,,,,0,
    EOS
  end
end
