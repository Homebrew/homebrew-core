class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "fe1d1a453b1ce64f6d27d1e89bef253ef7be2938cb901508d2845d71329b8ec5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40ae91dc1e12fb564c3e791c2484937211745cae520bd7afe6ac553221e4e3dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8eb2972f00a67f44620b71e945786b7c936048253401821195e9f1da48562a25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d684175ef6390184f794494da96856b71d05f653466c071f8591cbbf8104cc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6655a733b87ded915ed853f68da54d83dab8e81a47e29aaa60b2e9e750dad26e"
    sha256 cellar: :any_skip_relocation, ventura:        "79ae0c05e3938abe0e2fb2c74fec5df4729058da51db0d355a19df6f1085759a"
    sha256 cellar: :any_skip_relocation, monterey:       "a44ba3b59449d97952f58b13c0a00cb162a459a19e4286937e61e431393bc369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06bad101c2c6dac097ca77664128d918500efa593b190ae735e6b115d99f2a98"
  end

  depends_on "go" => :build

  conflicts_with "rush", because: "both install `rush` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
