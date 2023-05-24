class Sccache < Formula
  desc "Used as a compiler wrapper and avoids compilation when possible"
  homepage "https://github.com/mozilla/sccache"
  url "https://github.com/mozilla/sccache/archive/v0.5.0.tar.gz"
  sha256 "8953d3507586ba7958da951be2319abde97e2a724f9eb612dbf2360efb4bf404"
  license "Apache-2.0"
  head "https://github.com/mozilla/sccache.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e90ab39d6bbb369d66dd2566043d557efab05006e9ac26d889bdf5c6f5e1390b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a4b5bd9bd23b799faa36a236ef80bf72f4e24222481710ba088fdd4cb1a2c6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3be90413a844d956fedd8a95772f417936cc9babd25180b76efa5fdfca185787"
    sha256 cellar: :any_skip_relocation, ventura:        "3c27eda728e32a23a5c49b97a90796f53582c45e3f153c06e738226fea747256"
    sha256 cellar: :any_skip_relocation, monterey:       "c4cf061c3a2562bc1a4aa6caf87654552cf7000d00e064190055c54673cb2aa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0699e71c8ea1651a91e5740a8dff85a1e59d7daedec499eda446925b3b247fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a304daac4e9e9db310ec5bd4c02dc652d5a6ceb3030c4f5c0c3a19e947db5735"
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
