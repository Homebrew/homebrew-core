class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://github.com/0vercl0k/rp"
  url "https://github.com/0vercl0k/rp/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "474101ec7c63502e7452b4782de0891dc8f9b5178af52ae1c7c2bf0ca768bf77"
  license "MIT"
  head "https://github.com/0vercl0k/rp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb1c3d0c682cb2aaff8d2b97fcbfd113d29cdddeb4c8febabda779fbba5ab9ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6201785871ec1b8d5a54a5cbd4b8dea9233398e43afc2e55f324a1c6ef8aed3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "500216c7233512f19e96023bee4004751ae859b0290b221b613dcad28f17c198"
    sha256 cellar: :any_skip_relocation, ventura:        "a870afc86480f917ccfbcf0e1cf232759d433a0f33a6fd3ec78926ec0e05b50e"
    sha256 cellar: :any_skip_relocation, monterey:       "aa4b6390399a35780500f8a0883b71d6cb1571832623b8bd857954e94e84ac52"
    sha256 cellar: :any_skip_relocation, big_sur:        "f26f7baaff9524bf6c6a51d9ffe822df425285a4f86830510ededa36e19805fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f99beaac2c5b4f80eb49b2f79357e73ff5f59f354bb63be29ec0c7a2d887477"
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
