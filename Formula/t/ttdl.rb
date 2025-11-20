class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v4.16.0.tar.gz"
  sha256 "29a4965ea243cbc74d8788aac775352413014143ff544582f1be551ba6fc85f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e0934dcad2d665ee9e29d98038069e5f634be5f5f2508e54c311f21ddc71839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2215dcb8f96c1d0d593618ba745b56d74a715626f644e91723950c182092e67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a995f59edae698171b0113c5ac19d13ccd11882e909ede6a64b1ccafc46511d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7817c8f82163a511b990025afb0f844f366f995dfd77424efdd8c7ee95d93775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2c5267f1969edf4508d155c94dfc52e8dceeafa2eb44b765faece5323e38891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4d0ab91deb2698d99228cd4fd11dda2e97993b2083ead6582850397e8ac7a88"
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
