class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "https://snap7.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.2/snap7-full-1.4.2.7z"
  sha256 "1f4270cde8684957770a10a1d311c226e670d9589c69841a9012e818f7b9f80e"
  license "LGPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "abb76d2d02504c5bbc694f446a88b35f5d6c5e44c06cdf9f2ddef874eada0a8b"
    sha256 cellar: :any,                 arm64_sequoia:  "0251dac8097c7643fbbf1003e422e44773bc86d6c356a8497b2a07bfa163fbdf"
    sha256 cellar: :any,                 arm64_sonoma:   "62a3c97124e8c82bd49a94b9c1273eb8745ccf6e1a9e179bfed9bbc6e117e43a"
    sha256 cellar: :any,                 arm64_ventura:  "e3169f10899c5bbc65ca3982e7ad9ddb27ebaff7577f9f9c8c0c74be8fb0f271"
    sha256 cellar: :any,                 arm64_monterey: "3ec8ebc46f5b20dafc71b4a2f3c55e0323df337d7fd01e959e2f98c439fe0afa"
    sha256 cellar: :any,                 arm64_big_sur:  "7d60b716e639ad9c24153b94a474dab5d11ad5889e492846ea87235d7abd9e18"
    sha256 cellar: :any,                 sonoma:         "7e71f373d8a05c5d5da25b25873add858ea0231d83fd0981d2f86ebe5171be8d"
    sha256 cellar: :any,                 ventura:        "839e29976a348f6196df376d1f4c13ee808a8aacd3ff9d64369c6b7a3c390385"
    sha256 cellar: :any,                 monterey:       "0e80fc31c025dc39b1b551adb4328023a0b9f99643d8e246ab644529b9b7e3e1"
    sha256 cellar: :any,                 big_sur:        "52d04e1646b47ba15e5877e8c24b8f2d0267a51d8b7b07ee47330ecd2c44d95a"
    sha256 cellar: :any,                 catalina:       "015a23b1cb6728a86716811511e51fba427c69febabd1af5507af31d77523802"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "55a95fc3a66a84a3cd2a26e57635613ef236d855cf21f42991b7bfc36cd7c58c"
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
    (testpath/"test.c").write <<~C
      #include "snap7.h"
      int main()
      {
        S7Object Client = Cli_Create();
        Cli_Destroy(&Client);
        return 0;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lsnap7"
    system "./test"
  end
end
