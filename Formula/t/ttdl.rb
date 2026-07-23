class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v6.2.2.tar.gz"
  sha256 "12dc4f62ee48914bf46e27c4367a697b4a4392677f5b49efa71e24802470889d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e3fffb79e314a0e0adc9b524dbe120c4d2e89847d9bc91d9409987cee0136fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd273dcd30e9701e9294343d3de1f2c6928eb76499c641274574d41974daaf86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e75eecf808d81d79966938058c4926a9ad0ab9a755f7b85fd40bd57baba18e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1188c8b1db6be817abb702fbcef73e702797cf460c9b959d4d2e7286a2b8662b"
    sha256 cellar: :any,                 arm64_linux:   "b78b6ff15271ab3b0db10b2cc588d4ffb2ab9d4dbf807ce8bd054770694abaf8"
    sha256 cellar: :any,                 x86_64_linux:  "4b518f10f8f953ab28dc8e528aac98d2caf3c94ba680e43e0e4300d78138617e"
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
