class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "474101ec7c63502e7452b4782de0891dc8f9b5178af52ae1c7c2bf0ca768bf77"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdfa362fde7e355ca6f744ba769c56ce5bc363395d03f9edc98f3ab2cc870691"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5d1f9a14df3dc6b306171c9ff3ca6d5040558460b086bc164e58b9e51e1a832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1815c0d63c6d81a94cc3f541be3239d728d6a65ce8e64b48b8ec6b17fc4fa1b3"
    sha256 cellar: :any_skip_relocation, ventura:        "8972c16a121e84298e409eb2e6c6a24f2752dea2284e619022554d5e561dd669"
    sha256 cellar: :any_skip_relocation, monterey:       "f1d38a7711b2980683396a0eff31c4a25caf7940fd3072a82617da6c30c17110"
    sha256 cellar: :any_skip_relocation, big_sur:        "17cdde7cc1903040ee1a81a2d95f6288b093ee2cf31019ae3e29515fb2f01bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec132fe23ad6b93063140db30ae2a264c89d3c1bc19a66b1b57cd97e1887b1cc"
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
