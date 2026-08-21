class Usbtree < Formula
  desc "Live USB device tree in your terminal"
  homepage "https://gnomeria.github.io/usbtree/"
  url "https://github.com/gnomeria/usbtree/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "a315eeeb559911fffb1c2a17b6ebd418143168c888db5d3b737b05d8c34b3486"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3006a1657a85f5502f5eead14438bc4ebcfcfec9adde720a5809f8b48c846e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "954642731713eebbfe339e8ba95eccada11ce104a55b1621f1d153411ba58a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bc6746eef4a18e6108ad2812192e1607017f8de9cdce39c91064793077fa4dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "db66bf5a4145e35a69e1273721f2651b4dae3a8ca3dc6c1f5cc50e3ae5d89d9c"
    sha256 cellar: :any,                 arm64_linux:   "efd72637c2b8c54ab00fc84e30f18968296a5c6a1f512ce39d1009fd85476718"
    sha256 cellar: :any,                 x86_64_linux:  "d5fd31cf9c054d961854fd66d6050e4303f2e3ff25ce4b707544467e2ea872c7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "controller", shell_output("#{bin}/usbtree --pci")
  end
end
