class Sapling < Formula
  desc "Scalable, User-Friendly Source Control System"
  homepage "https://sapling-scm.com"
  url "https://github.com/facebook/sapling/archive/refs/tags/0.1.20221118-210929-cfbb68aa.tar.gz"
  version "0.1.20221118-210929-cfbb68aa"
  sha256 "51ce336f1eb382e591a7384d0292cb41fafbbd92cc701ee74b50099beece65e4"
  license "GPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "node" => :build
  depends_on "python@3.8" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build

  def install
    cd "eden/scm" do
      system "make", "oss"
      bin.install "sl"
    end
  end

  test do
    assert_match "Sapling 0.1.20221118-210929-cfbb68aa", shell_output("#{bin}/sl --version")
  end
end
