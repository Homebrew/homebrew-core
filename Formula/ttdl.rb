class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "c20608c20233aa4495eabed631e70448e307e8ab0b006f328d6e72d3278311b5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51bdbe7add454bc0aaf6a6ea87ae9fd645ebb3c7fd5c125c2eddfa9d86d539f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5f0a4938284784953d815f18a3c1bd7802beb9b5f5fe359532629676dd50293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b7ee2163cafa8983c0c011f1c11f0c0ccad766eb92a753001e6dcabb6f492cc"
    sha256 cellar: :any_skip_relocation, ventura:        "d3e45eeacdeadae2e1adadddaf0e1f473df3e9bec8006b2157d27012316459d1"
    sha256 cellar: :any_skip_relocation, monterey:       "eb88e39e38ab03a35b858b35f3f65bc8f7d01c2caac51278fbce7c92a3297dc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9424472f8baa2352fb20c553257091ee0c5b3b44344678f4c812ff2f745bf0dd"
    sha256 cellar: :any_skip_relocation, catalina:       "af1730a74106f8eab864433878f9e60217aeef539dcae12a77d8f812ede3d946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124a554e2865c53095f3bbfbac2e33efafc346bcb5949eca8eed3e34130237d5"
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
