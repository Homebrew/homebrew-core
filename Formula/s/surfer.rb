class Surfer < Formula
  desc "Waveform viewer, supporting VCD, FST, or GHW format"
  homepage "https://surfer-project.org/"
  url "https://gitlab.com/surfer-project/surfer.git",
      tag:      "v0.3.0",
      revision: "1a6b34c44ea0e5089bd55d0bce1297aa1a02e6ef"
  license "EUPL-1.2"
  head "https://gitlab.com/surfer-project/surfer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4457f78c27f1e938def02a5a0dcbbcc2e0a321c74f8537c04f509802c9f0b8ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e97543d0f251a4f4b6af33d51eee1756034d89b5b56a1635950ab1e238aacad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03096cd206a1e35ce940edbfc933dec9223af66b13020995f74bc31e5de6e0b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8deccf748154f2694fb130a855db4489f1ead1a2a373c1f5fa4fb7440718c64"
    sha256 cellar: :any_skip_relocation, ventura:       "c4153c7564eb8c1f70c138b984d50497d335b6f545b2bc1812b7020b558e575c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03ebf3b987048837c04e1308da290bed70d14b3102bd8ff910e20dd71965f1bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85f894ea7612f3fbf2c10be6b238e4cfa42fcc694c4d0dbc4b847f6fe4010fcc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "surfer")
  end

  test do
    port = free_port
    (testpath/"test.vcd").write <<~EOS
      $timescale 1ns $end
      $scope module logic $end
      $var wire 3 # x $end
      $var wire 1 $ y $end
      $upscope $end
      $enddefinitions $end
      $dumpvars
      b000 #
      1$
      $end
      #0
      b001 #
      0$
      #250
      b110 #
      1$
      #500
    EOS

    token = "tokentoken"
    pid = spawn bin/"surfer", "server", "--file", "test.vcd", "--port", port.to_s, "--token", token

    sleep 2

    output = shell_output("curl -S http://localhost:#{port}/#{token}")
    expected = "Surfer Remote Server"
    assert_includes output, expected
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
