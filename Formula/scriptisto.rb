class Scriptisto < Formula
  desc "Language-agnostic \"shebang interpreter\" to write scripts in compiled languages"
  homepage "https://github.com/igor-petruk/scriptisto"
  url "https://github.com/igor-petruk/scriptisto/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "0d96b54589e9efe6b2994ebd66b8c2a6b0971baaec66798da53b0978bdce6d28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "925d24e6cd29a5240be55a4cde9b783003742e7b2ea16164870ece16d8ab1c65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22db05ed07bac30043e313e8d564635e6273bcbd67f22daf392f8b3b1f7a00f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9febde14d2fe86bc88342b4cb51d4bee4fc4b9df757e454d27b886ff25534d4"
    sha256 cellar: :any_skip_relocation, ventura:        "d6e2330d8ee92fbde9a16c5a5d85bdfd48b1fee92bab04c7c4bfb5abc9390377"
    sha256 cellar: :any_skip_relocation, monterey:       "f207151397102480f07eaaedd0fb97782fda6e8fe947a846eb219e73ab96e71b"
    sha256 cellar: :any_skip_relocation, big_sur:        "deedfc1ef677ac7134d0eff3832f726e4260d8c51e1eb11e8459bde63af5698d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d018f86f84775751e42073177fa38feb0d492f252a24846b7eb4fc8a0719bfaf"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #!/usr/bin/env scriptisto

      // scriptisto-begin
      // script_src: main.c
      // build_cmd: cc -O2 main.c -o ./script
      // scriptisto-end

      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}/scriptisto ./hello-c.c")
  end
end
