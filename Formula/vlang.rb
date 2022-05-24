class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/0.2.4.tar.gz"
  sha256 "8cdbc32fb928051ce7959dd943af3efee26bddc4ed3700a1cb365be73a306bf9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd921f6a5fececa1d04ad1361ba19c1da4ae361b88d3862fa02f7747bb87b0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fc0d5fea246584518fc01c59483f07ad89274c78606a70cb4623be28380f7d0"
    sha256 cellar: :any_skip_relocation, monterey:       "4fcb57b3de12ecd576bc4495d7446872ae68218200ec3e32c7889f59f1e8e2c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "19266863aa98b5a45d9b423db1924fd03470453ed9e5b8ca958fc4abecf6f88c"
    sha256 cellar: :any_skip_relocation, catalina:       "60e0f440e473d751fdc8ad1704105f8c1ac870a742740d7f7335e39c47a8929f"
    sha256 cellar: :any_skip_relocation, mojave:         "03d594231e0e381fe454dfde377062e9b1d77f1845e3863896027fc856455829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9db9337867f25273de9744c53e8956245e6c17531fde5cc57bf39520ef4763"
  end

  resource "vc" do
    # For every vlang release there is a matching commit of the V compiler in the format
    # "[v:master] {short SHA of the vlang release commit} - {vlang version number}".
    # The sources of this V compiler commit need to be used here
    url "https://github.com/vlang/vc.git",
        revision: "fd5f57740ff6d7a8566b774318df54c2fa460f92"
  end

  def install
    resource("vc").stage do
      system ENV.cc, "-std=gnu11", "-w", "-o", buildpath/"v", "v.c", "-lm"
    end
    system "./v", "self"
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
