class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/v3.1.tar.gz"
  sha256 "7946eb9de2bd702023f4163901be53b2745850e4b929cc99dfd390dec1638030"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a739893208cf02d454a0cc2667594b8785a1f05bbac74e4895290cab7d6a973"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8c7b24e73b31ab158e62c7be6e5a213ac67ff49b6c86f47455ae967bcc525f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5d6d1617ef238125a334f285de579917c86c982df40fe6aa539c1edee74c0a2"
    sha256 cellar: :any_skip_relocation, ventura:        "66a5792346a087a5006a1f18554f9c9f7c93557d0e9b5693568c55b859af3e1e"
    sha256 cellar: :any_skip_relocation, monterey:       "c3b60c99a1fe8331be5fd6080f59f792394087b41e9735eaa46590ac0c7107f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a889017475677de613cc13ab07bc7027adfe54050b62b1d0b7da72007dc9fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b4beb6169ce31663dd24fa61a414f704a1a1a165109e2ead9292a201b3aac3a"
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
