class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://github.com/refaktor/rye/archive/refs/tags/v0.0.40.tar.gz"
  sha256 "e3b49d361f8633ad2a6e972d613b120c87fc21091199654eb2eed80ee379eaf0"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acae1623b60c5e624b24a25eb44ba24094884472f4f875aa8314c10698ad4955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219b6a80c83f132d3969fcf832c8c132116b85597eccd4831b52d00b450111a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c65e06f189d83a4856880f1d9075738e2d93d4032f9dcfcbd26782e6884d96cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d00f5b2f16cbcdea2e38c81688b966100c296dc8902519ddd0ccc42ebd2d2a6e"
    sha256 cellar: :any_skip_relocation, ventura:       "6bd8185faf5a16e68b4f866822d31a13a8013fe63119e21eeb0d1474695f7dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1a0b37ddd1c197d6e9dd9c5ec78a942c7771d9467b84d0c75a69e5c0634552"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end
