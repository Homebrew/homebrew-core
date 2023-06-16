class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/v3.2.2.tar.gz"
  sha256 "3054a25dab7b49885b212482220e86c89aa7f7e9d902ccb9059e827b4e62d745"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0791dcd7e1a30dc58610055766dcaf509918ba46beb5d5854ebe73e53e172e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afcc7f0ad34f38920b20853b35f2a11186138efae52500bd2df34d456e7a5d66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e351139e0d3782788a3c99202c30db69a7682e964737eb52c46af70de53e61f7"
    sha256 cellar: :any_skip_relocation, ventura:        "c707fb7c3367d3f35fbb93c0425c30fb9e7a6c24a071c9ed0c5db31e56706e4c"
    sha256 cellar: :any_skip_relocation, monterey:       "2dafc93aea6dcaf9a0d04ec5d0e9895154167db184b056f0d1fdeecbad7d1d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e55d0d33c45f05c8dfd109c39e211fbdd8855c5832a2e8e3c35f23041683abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3b452b620ff2debb75af1950cfe4319cf7ecbe05ae58f01123791aa9998b87"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"input.qasm").write <<~EOS
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      h q[0];
      h q[0];
      measure q->c;
    EOS
    assert_equal <<~EOS, shell_output("#{bin}/staq -O3 ./input.qasm").chomp
      OPENQASM 2.0;
      include "qelib1.inc";

      qreg q[1];
      creg c[1];
      measure q[0] -> c[0];
    EOS
  end
end
