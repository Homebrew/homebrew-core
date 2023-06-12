class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/v3.2.2.tar.gz"
  sha256 "e22dac337f98a73b6f59a4f667b01bc5381a0e950b64bf027e0512b350c1b634"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31c67862049db3b591896b2732e09f2e3a5d9f1f237419aa89ac8b491cd9ab69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d63dee0d6f6bf81715a06331e1b7b221e061f012feb20851864b52e57f9c779b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db07f57b51ff66353991b6f3e24d47fe63b0ca839bd3d80399cc89e9739b3fd0"
    sha256 cellar: :any_skip_relocation, ventura:        "7cc35da32118b1378f093ed8ccb2cac6fbc5b25648a344eaf1108bc689b63953"
    sha256 cellar: :any_skip_relocation, monterey:       "d190c45efc18b1222bbdf5ef05cf4f1b82cd43bb18927b61de44fe95e906efef"
    sha256 cellar: :any_skip_relocation, big_sur:        "15d929b82648bf0bab71c959ed890b5eb8dcf9e4068df50e94cd1e294cfce729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "937f3a87b4bc534f553595e04b27f034152b0e5b8c124c3cf753a8cdaa9aad03"
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
