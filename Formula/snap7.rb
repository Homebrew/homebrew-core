class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "https://snap7.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.2/snap7-full-1.4.2.7z"
  sha256 "1f4270cde8684957770a10a1d311c226e670d9589c69841a9012e818f7b9f80e"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e3169f10899c5bbc65ca3982e7ad9ddb27ebaff7577f9f9c8c0c74be8fb0f271"
    sha256 cellar: :any,                 arm64_monterey: "3ec8ebc46f5b20dafc71b4a2f3c55e0323df337d7fd01e959e2f98c439fe0afa"
    sha256 cellar: :any,                 arm64_big_sur:  "7d60b716e639ad9c24153b94a474dab5d11ad5889e492846ea87235d7abd9e18"
    sha256 cellar: :any,                 ventura:        "839e29976a348f6196df376d1f4c13ee808a8aacd3ff9d64369c6b7a3c390385"
    sha256 cellar: :any,                 monterey:       "0e80fc31c025dc39b1b551adb4328023a0b9f99643d8e246ab644529b9b7e3e1"
    sha256 cellar: :any,                 big_sur:        "52d04e1646b47ba15e5877e8c24b8f2d0267a51d8b7b07ee47330ecd2c44d95a"
    sha256 cellar: :any,                 catalina:       "015a23b1cb6728a86716811511e51fba427c69febabd1af5507af31d77523802"
    sha256 cellar: :any,                 mojave:         "71aff7cbb3e78369d6b9a93887820dd7def1afe382ed82211be313942e1bb81d"
    sha256 cellar: :any,                 high_sierra:    "b0d670ce6a2d780d13cfaa3346c6aa701f280a85be010dc42c802d6ebd028694"
    sha256 cellar: :any,                 sierra:         "e04dea88411f3b444dcab340d3f11bd739fb853de65701e727546a9481981924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fbbcef4c1de91267df9cfad2d3be40570c3be564c5793d874c11452780dc315"
  end

  def install
    lib.mkpath
    os_dir = OS.mac? ? "osx" : "unix"
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "make", "-C", "build/#{os_dir}",
                   "-f", "x86_64_#{os}.mk",
                   "install", "LibInstall=#{lib}"
    include.install "release/Wrappers/c-cpp/snap7.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "snap7.h"
      int main()
      {
        S7Object Client = Cli_Create();
        Cli_Destroy(&Client);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lsnap7"
    system "./test"
  end
end
