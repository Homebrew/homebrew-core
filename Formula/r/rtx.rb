class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://github.com/jdx/rtx/archive/refs/tags/v2023.9.0.tar.gz"
  sha256 "0b853518bd5aac2f38f79eae651c3df6c156507a6dd37b16884fa239dce7a0d9"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c7ae1d4a7ef93f108e8d241d688ab5b39809ce2ebf0790636820a6752fe7bca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffeeaecee97500897721546571fd6ed44a77676d3cf273508db8e35011d6aab8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3f127c12b939b07e961fc595db3ea9c8d51a2729ab69e344e93d1e3bc548e15"
    sha256 cellar: :any_skip_relocation, ventura:        "e5fa543334804bbb35e56700739ed5bcf31215dee9e790365bc03b28349f8e5d"
    sha256 cellar: :any_skip_relocation, monterey:       "cf49360d36d6fe172a26d0d821f60783c9d440abcf988b2b784d06d2df37f7f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "000be899bbe644cd26afbb8aea69a39b86f1388997edaa095f62161576a69aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db2c7d9f893ca2b65948812cda2d29b70d1351f928997d2126a83e9fd04e0ab"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end
