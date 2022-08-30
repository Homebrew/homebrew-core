class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "c20608c20233aa4495eabed631e70448e307e8ab0b006f328d6e72d3278311b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8dc7561fd77b8211b708a0950079f9710dbf6db0de9237eab1aab0c8ab1e133e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e1cc043740747660e5de290bdc3b9b976b1994f654db0f9b688febc3e7c3e3d"
    sha256 cellar: :any_skip_relocation, monterey:       "43bba175ceb037655f149c1bbac8ddffc7e5d262481bfc2aca2389ea0f91b050"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8f5808f37de68abcaf0a247f5d64f0d6ea36156ade6bdd37ae823e830069312"
    sha256 cellar: :any_skip_relocation, catalina:       "44b490f82d9756cd36153e1b19bbacb12cb8770826b9aa00159912826fc8af41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a60c50864822d63e23b2eb0e0a622a7b3e6e0ea8a381dc81d8165b62909cda72"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
