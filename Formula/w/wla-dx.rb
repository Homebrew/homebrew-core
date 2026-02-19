class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/refs/tags/v10.6.tar.gz"
  sha256 "010c4d426fd1733b978cbca7530a5e68bdfb6f62976c0d5ff7bff447894e19a8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)(?:-fix)*/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "11d1d2d3fdc767d15e21dd37a176fe35438cf438c8ff05e9344e69da674acac2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f89cc32f88279298a841ee744557214695dffdc76c35f43f28610715c38b35d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01e0f38cf29c205e76cb0950a41847867d3ee007e877f6607e5e5c352fe222da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d86083d1dd34ccbb5f8309052d57e9b5ee52de04f7382510f41ba82e19d3b1ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ca9f57e6ed396fd20774c44c4619e4b9583a772d3d0751ea90751e3ddb06545"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ff72ea731a055cf23c426ab45fe5e33169ba1a4979c74ac90a9edd84a04730b"
    sha256 cellar: :any_skip_relocation, ventura:        "db9b75eba0fe4403c2c41faaa0fc7d49bf173e32c8240718d18413aee0609d35"
    sha256 cellar: :any_skip_relocation, monterey:       "6397fad5d0f3bbdb81022766ca0784206cb611dd7db402fb7eff80bb703860b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "08c9e8db294a9c53c600dc9ed33dad82e58783710f679c3961dafe5c7f04d41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5860c11c5bbbdb62949e01df2af3d006f8315f5d30a2d4f4c25740a57ef883"
  end

  depends_on "cmake" => :build

  # Backport support for CMake 4
  patch do
    url "https://github.com/vhelin/wla-dx/commit/6fa1f673f010e4fa4571c40929019cd7e67d1bbd.patch?full_index=1"
    sha256 "08ba18fe27c6b0ff0bad4e9ce15a4e76be5626407e03ffdf1c19228902e02493"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test-gb-asm.s").write <<~ASM
      .MEMORYMAP
       DEFAULTSLOT 1.01
       SLOT 0.001 $0000 $2000
       SLOT 1.2 STArT $2000 sIzE $6000
       .ENDME

       .ROMBANKMAP
       BANKSTOTAL 2
       BANKSIZE $2000
       BANKS 1
       BANKSIZE $6000
       BANKS 1
       .ENDRO

       .BANK 1 SLOT 1

       .ORGA $2000


       ld hl, sp+127
       ld hl, sp-128
       add sp, -128
       add sp, 127
       adc 200
       jr -128
       jr 127
       jr nc, 127
    ASM

    system bin/"wla-gb", "-o", testpath/"test-gb-asm.s"
  end
end
