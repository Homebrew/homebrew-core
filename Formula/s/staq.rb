class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/v3.3.tar.gz"
  sha256 "2a1232474f7b7fc0153c18f49e6231e82b6f9c3d1f9ed506bbbb578972cf5067"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd0b272fdf61d8aad9e907f1fe4f87593380df1acb459950942d32cb9425e2d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3907dd220835eae37adc2e540b0e79814f27eb0b132293dfc60d095854a9430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f469adedfe52fb32d7cab8e51efb57eb94bbd318fcd76ac987825aad606ea15"
    sha256 cellar: :any_skip_relocation, sonoma:         "269a2c8e0f94d7f40eb235ca6bf49106ba6551ff320970b24315b32e4d6ee8cc"
    sha256 cellar: :any_skip_relocation, ventura:        "873ceef30b1ac455f723555db46cb2ffcd2daa22fd50ab6d4022da29c8da71cb"
    sha256 cellar: :any_skip_relocation, monterey:       "0c97108f8acf0ef3c6bf8e50535b985a1ec3469cc6bf69dba65fef328310eede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa663721999cca606998ed744cf81f9a353d00ac1e851b0b191397f9ca419f7"
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
