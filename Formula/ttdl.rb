class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "66115d80ac54a8024f191e81f72f9b7f6dda9db1de907f3570c1939532ca9e72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efeb2b64691fd39f02cf464c056e0317afbaf0ff2bd83865d6e957eb30718ced"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dd150c899c5a1c8cb0c8b5064b8d18c27509cbe28651b22b43304ce775402ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df1efa9ebbce2832db624f281f43cee2501bc83b88065348287337e6948fcaf4"
    sha256 cellar: :any_skip_relocation, ventura:        "ac6489ad8763a435ce0b791510d25064f55a685a45f5fd4884d78a16524aacba"
    sha256 cellar: :any_skip_relocation, monterey:       "4a13c4be962d04971e2564b012f36cc442eeeaf1710f6275c913d8f2bec70424"
    sha256 cellar: :any_skip_relocation, big_sur:        "950ea4b2f35889416bb70a6bbc9db7b135733d96084b24482d8a94b393dd18f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1e38171984fdd5432e36763620cd0dc00032129da71ac9d428709c710a00699"
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
