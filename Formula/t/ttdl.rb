class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "f66594f2d2841750343d0247347c7261ad1df96d8772eeabf0651437f92e940f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceaae8d43b7895d9effc31eadc0025799bd611effeed37cf2686c8782d37938a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c275772aa8db07b23bbd61e499dab260fdfaaecccab325bcbb3bf1f1fcfbd159"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7af7f3d981adf21eb6739d359ec313030f3a2886bd41543101a235393f7eaed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ab715ccd7c48681ee7eb8d1a61a2308e91a71548aee7a628e7346760b4e3964"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e7ed6fc3e431f9521633b4dfa3cee1012b9fab947c2d413dd87c3ff7b5a7de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6400700ad7e27f1d0783739d17824075f3e0fe2304cc1e23d8db72e802f8b25a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_path_exists testpath/"todo.txt"
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
