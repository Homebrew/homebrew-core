class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "668cbdc4ff02b8774f75680f43fdd38f924359e2a99ddd8291beae9606e09f02"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f0b383f4a76f056c51858a85e93297e26d82356069c3ac1926f6dbe762d186a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c538f779acc275b3c613a2a47d4436f54a5f706d81522ae7c8d8ee8bc0cbca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74c3b3a0eb50b7a6b6c9df3e23568220a98a66becfa38e799e322b3daeb164ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b1b3226e4adf09046fe02a7378147600ac45dcae81864900f27b17c17b39f1"
    sha256 cellar: :any_skip_relocation, ventura:       "c58342298a6cadb2e7589487fdac98b3af13176be08c4bd390c084759569e29a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452819270a64c7f92bba7b1ca9fdf8b970171ff11f1424d4e9d177e1f0377e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cbf2ef84363fd1baf5ac98c0484106526da8a14a687580c56c1961d8d277b35"
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
