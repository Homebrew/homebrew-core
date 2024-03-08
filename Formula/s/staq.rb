class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/refs/tags/v3.5.tar.gz"
  sha256 "838402b6ca541200740cc3ab989b3026f3b001ebf3e1ce7d89ae7f09a0e33195"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e946d1bbfec0e8718098f9697b7d138cfc05ab82e1802ebee0fb8ca361cc060"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf40378514e78990329996cace89fd39ec4ebe8755f5e2aa9af3137a2a3a8a63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d1d7076ec255cc7cf7273c17ea0efcf1496e8572f945be55ee6ba45dfe37b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b2d8036217fd420616ebcfc627103f9e3c4905a391d1add66394547913bdd0b"
    sha256 cellar: :any_skip_relocation, ventura:        "374a00d133e35afd7c44e49d2e19368ba3b397dbaa47e63ba5d88db721e8586a"
    sha256 cellar: :any_skip_relocation, monterey:       "a2e0403ce28982817e561288e1fe892968ba4f11d04adb4e7d30986f3a1d2f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2abec55755901fbb2c340a66ed2b6bca76176d3e44e4ce433e4021ddf93e9770"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-D", "INSTALL_SOURCES=ON", *std_cmake_args
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
