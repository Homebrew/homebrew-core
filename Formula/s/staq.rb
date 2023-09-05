class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/v3.2.3.tar.gz"
  sha256 "048bba1c2d78bc6b641ee9ba71788cb66847e78e8b47ca54effea49e76c4565d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc455153c9bb1e2c1ab2735549595c8038bc81c1dc199d3954ccd6b17c033eaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50531c8d02ad552eac013e4db68af439ba8c96e5bd030454bb5dc72cfadc9c22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fade095b71096ad7edf92cf8db82669c798ccd6ce782602f56d0ca354ba1af59"
    sha256 cellar: :any_skip_relocation, ventura:        "eee004d9964a81988665a1fecb3083f74309c293a38fd0fe1bda36343f6492bd"
    sha256 cellar: :any_skip_relocation, monterey:       "ced86c03bc0db24e1f0b9d22812898010ba9154929f85ccf8dcb14ae2e77d901"
    sha256 cellar: :any_skip_relocation, big_sur:        "34c82144382e8dc438a39e64941ae14dee0e41926d6c69fb254144f33deeec7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6e829fdde807b9861154c871864e9ed53578bb82f911f35c5e64e3c9e4e66c"
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
