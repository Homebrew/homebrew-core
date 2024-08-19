class Staq < Formula
  desc "Full-stack quantum processing toolkit"
  homepage "https://github.com/softwareQinc/staq"
  url "https://github.com/softwareQinc/staq/archive/refs/tags/v3.5.tar.gz"
  sha256 "838402b6ca541200740cc3ab989b3026f3b001ebf3e1ce7d89ae7f09a0e33195"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f29a73fe7f84e7ba37c5b09f433ecbf3388ab8131b2e185a7890cb42d444c025"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "609b7cff660d38139392cb80745e992ea20998886c38c9f3e1b99fae0c4540f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e15069ca3e7830d6d5147f60d03dafd118a8636390d0c0584f5e03af46985d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b693740d394888d92fa991b20a5740a2cd27dc28aa29a26a9b232128220f95eb"
    sha256 cellar: :any_skip_relocation, ventura:        "4fc208e0bae6d80eeaa8d440cf13634dc93b07eb0f2fdb138480c0e4f39e4188"
    sha256 cellar: :any_skip_relocation, monterey:       "68ebaa20a66420c76631803f6285345b27eb71eaa4dfb4f2e95dd3208dcd1f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbbc33cbd8374d3218dcf4da026f5733bd8bed35b8ccbe1c493e9b2618970eca"
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
