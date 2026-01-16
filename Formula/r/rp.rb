class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.1.5.tar.gz"
  sha256 "045b0d4a7d955e281e35b2f52fa8f23e4abad55256c3732d22469af8112f5f63"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6e7d0e301739ea8b86bf88427a9795ae43af3acb7828e979872cece18961092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b0079ef8a1dd420686a4e7f4b9842c32993ef42112604bedbb34064715f739"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "313292a48d7096f7ff4f15e48a8849aba3e33c3ce468fcf2994c68114e1cb69b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1398c2e1b74b7e0f2902d9bcdec0197469d9e6bcb1f32aff45562cce3f7b4a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f36ceb5d5cb7b6f944bbb4be0d4e74012ee0d36a8cb0a13cd5f4bdc1e8e41750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc42c86ae8f60d97ae8a3eae5c738d4c49cde9ee31d2bf705d68def1d62adbd"
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
