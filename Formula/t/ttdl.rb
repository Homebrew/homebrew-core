class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v6.0.0.tar.gz"
  sha256 "64c76f8087b954190adc4c9a5bdaea276b3384edc9cb511cc7abd106fbc91d3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb17f564701357988e7fef1f922339e79de38bf3f75f1be21c2e32870fcc34b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc6c2bcffd74864b94e1bd007e2f62856c7997c4e37affc7d9216983acdac4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f31a8a1789cced0cb8243eefc2ac174279782644128c807e5222a4eded1c1296"
    sha256 cellar: :any_skip_relocation, sonoma:        "15a7a9447895de9fc5093f36cc219d1675acc16aa3acc78201d762251b24d5c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31cef48363165273e84925df70231b15dad3778a8dd7bbd2593fbbec5b8214a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277c6203f5d2a594bdefdcc9c204cd77a7e4727711109b5fc178e5ec689b4849"
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
