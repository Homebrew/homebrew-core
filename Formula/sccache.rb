class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.4.0.tar.gz"
  sha256 "361d2e4150d5bf9a563face9113062335dab98f4c726ad58c4bc77252051e676"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "794a4752acf8e95331c3c10bc9103595ffc40641c2be8b6d9a228bfd607a5bfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84a5e5e59a183663ba3d343c1f08fcd70da4f03fa0c15283923eb662044b1607"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24bfa61de01e9db585c84886671a3773ba7872d45cb45e6d5c48e77f74bfe1ca"
    sha256 cellar: :any_skip_relocation, ventura:        "59af95cae285d37bca82ab983532bdabad18e7a417028ac9cbf9814ffefde27a"
    sha256 cellar: :any_skip_relocation, monterey:       "9e73ceaba258e6aa6e4a2e5a07405d6c2d90de90aa09de0354f241f9a7809b1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a1cd85ee1e348804ab9fe9de9179beb22c56ce63c4e31b233fd5b8e63b79b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d240a9ca714400e84e13e585464472e35ec105de155a26f98aebc44572ee3591"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix if OS.linux?

    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/sccache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
