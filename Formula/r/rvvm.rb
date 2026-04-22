class Rvvm < Formula
  desc "RISC-V Virtual Machine"
  homepage "https://github.com/LekKit/RVVM"
  url "https://github.com/LekKit/RVVM/archive/refs/tags/v0.6.tar.gz"
  sha256 "97e98c95d8785438758b81fb5c695b8eafb564502c6af7f52555b056e3bb7d7a"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2d1713f3ce9b6982d67db642cac2283c31edc0c0fbbb751a3827ba623678595"
    sha256 cellar: :any,                 arm64_sequoia: "665ef767abe8d4a20498730877e1668e824d4aa6cdf3a10c498a89ee255a32c2"
    sha256 cellar: :any,                 arm64_sonoma:  "2aba59be38ed382619f9d6975974d588856ef865cb5bc6ebfed7c09c83a02911"
    sha256 cellar: :any,                 sonoma:        "c0f67339d17e090fdd3e81ec635247963fbfbb90228dd2b7a1b1db2aafe590ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0626c4ac49b1b181da04f6d285c26bff39e475dde61dcf6158a3ad416727f48d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4be0a88e77f37c70fac2bd4d9bb49814bf8bdeed9a60840d4503a8e7920e7dd1"
  end

  head do
    url "https://github.com/LekKit/RVVM.git", branch: "staging"

    depends_on "cmake" => :build
  end

  depends_on "pkgconf" => :build

  on_macos do
    depends_on "sdl2"
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxkbcommon"
    depends_on "wayland"
  end

  def install
    if stable?
      system "make"
      bin.install Dir["release.*/rvvm_*"].first => "rvvm"
    else
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      bin.install "build/rvvm"
      lib.install "build/librvvm.dylib" if OS.mac?
      lib.install "build/librvvm.so" if OS.linux?
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rvvm -h")

    touch testpath/"test.bin"
    output_log = testpath/"output.log"
    pid = spawn bin/"rvvm", "test.bin", "-nogui", "-verbose", [:out, :err] => output_log.to_s
    sleep 5
    refute_match "ERROR", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
