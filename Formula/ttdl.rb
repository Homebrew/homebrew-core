class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "af79641310e688fbc6e558343bb5835926cd0cf25ef45c4515c5cd12292572ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "296077ec8659abf577ba66916948c4f79e687020642ba140c2ab74a71b5211b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "482127cf045afade9d0ce09aacbb64d8d01f16c16c2dfe9d1a6e7aa0e50de4c6"
    sha256 cellar: :any_skip_relocation, monterey:       "54e64c82144a9c51c47f41c200ab5ca8e1d7d4fa16c1ce27871c964609277d88"
    sha256 cellar: :any_skip_relocation, big_sur:        "db274879368c8dec1599b1d9d8113f609aa580226e5fe1bab2c0511d6053e193"
    sha256 cellar: :any_skip_relocation, catalina:       "3bb14751cbb354274f5af06a616cc3d66eb2d108d1732aaef8f41b559da6adea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c71bf6c9f70b87f5a57925ad97a509177ca398fbea6ceeabbe845eaba8a5c7a"
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
