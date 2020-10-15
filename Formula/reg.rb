class Reg < Formula
  desc "Docker registry v2 command-line client"
  homepage "https://r.j3ss.co"
  url "https://github.com/genuinetools/reg/archive/v0.16.1.tar.gz"
  sha256 "b65787bff71bff21f21adc933799e70aa9b868d19b1e64f8fd24ebdc19058430"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "566141035e7c94c92a4422addea68ea86431916055d14bfe5e20de79c3a6451c" => :catalina
    sha256 "fc74e858cf6aa00783292b40d24ddbe0597d53c0e2f04c66dbbb0f103cbb50ec" => :mojave
    sha256 "6c834ffc790787be203c01f7d153971f34d4c75f70245058717e4a13f0afcf79" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "buster", shell_output("#{bin}/reg tags debian")
  end
end
