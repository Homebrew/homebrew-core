class Surfer < Formula
  desc "Waveform viewer, supporting VCD, FST, or GHW format"
  homepage "https://surfer-project.org/"
  url "https://gitlab.com/surfer-project/surfer.git",
      tag:      "v0.4.0",
      revision: "9198cc497aec2249ff7459df03fed628c9996578"
  license "EUPL-1.2"
  head "https://gitlab.com/surfer-project/surfer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b543129fdd6f45a43b42a5597a086affe544550dec1ca3167cde03c686973c59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e3981f15646136c67b7c2ec24b6e1e2a0480bd3410ea13973ad6b270531930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "080b09915a5e2dc6c5d3ccfec24a34f399c384abbe817d1b17b4fb57d10c634b"
    sha256 cellar: :any_skip_relocation, sonoma:        "536b3f9ea18ac279959209e320155220e9b7d31042802f51db3a44ca4dc28efc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f223881e9a266cd4383e1f870cdd669b73df418b3573c2ab3e6cd44e92d145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "748e1352790bd92384ab4e01570a4a47b7a98ff8f19079ff60702612c0479354"
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
