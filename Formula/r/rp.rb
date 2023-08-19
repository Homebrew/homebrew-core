class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "7d0b523e123315c1a4e66ab6386a733ce3200d0cc2c489f04edbe398a016a160"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd40e9a4e27e956fa2be3591ced32e8b0022c5c487f4c5cb20437db094eb36d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d5f2862e0a53666572c7b03e80b3c652440f063b435d616f135bdfb0462ccdd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e983fea67e1c46a4aa86b9bdb193c07519bfa94f137a975b106088011d200f3"
    sha256 cellar: :any_skip_relocation, ventura:        "55eb4dce3cd61ded9718afecbab81d156a4d1d85786d7f10223a8492286233ce"
    sha256 cellar: :any_skip_relocation, monterey:       "3f71e97c714faef8b03f0d1f2e8b787a6db8cb20a8853de18498d351e22c19a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb1a502f06dd14112dd034e6f81a7e3c398d36700b084c9bf1069a432f2ed6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a9224b577e2a01fa32da55b29c9cd070875f4a24517c8e25ca9e0a7a5e0d3c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    os = OS.mac? ? "osx" : "lin"
    bin.install "build/rp-#{os}"
  end

  test do
    os = OS.mac? ? "osx" : "lin"
    rp = bin/"rp-#{os}"
    output = shell_output("#{rp} --file #{rp} --rop=1 --unique")
    assert_match "FileFormat: #{OS.mac? ? "Mach-o" : "Elf"}", output
    assert_match(/\d+ unique gadgets found/, output)
  end
end
