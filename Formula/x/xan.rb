class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.50.0.tar.gz"
  sha256 "9742e383649076b1348329e2430648267e22505b6ca35ce5006f614040f73d3c"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dda1e14e5a4191bee289018c33305f52af3e9c679aed92837b342002d3545430"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb0523f62429de464726a3fb3312a200c6c8265ec42675f01b70cd0a72c63d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6114c83139e3c4f93ce42e654dbf2f1ed556c676a5ec595035e1eb1e5a831e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee425dd63a9b7ab72e79ceb8cde3bda0fe4255ec855d57b570c5c15b5ccfe625"
    sha256 cellar: :any_skip_relocation, ventura:       "8a6d8dd8a04c012d4cb9bbba91b5d4a3db7c38c04a750743426d44251c698c6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2f572d9c30f0dc4b110ca503b492672c941a65598f2fb065314782ebd219a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce6fe0210b7f6f1af0df33f06da2224d434544c44f59b778c284767f8b36d7c8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
