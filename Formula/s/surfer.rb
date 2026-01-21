class Surfer < Formula
  desc "Waveform viewer, supporting VCD, FST, or GHW format"
  homepage "https://surfer-project.org/"
  url "https://gitlab.com/surfer-project/surfer.git",
      tag:      "v0.5.0",
      revision: "0be6f8ad869060791ad0864d77f2f842cd27ee65"
  license "EUPL-1.2"
  head "https://gitlab.com/surfer-project/surfer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58ef6005442327e9354c768266ee9a25f98127ef88c997d6c994b8c753963e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2553f22564be9f09f2d049f5a35ced3d79cf42c6a8c2d2af97fc090a99d05f58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ec775361fd33daa3e96e2665efd71c0541a93e1651f44511ea1b3227c38c8c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "69b984912902e8059dff123a457d9fa4e22c8168ab179dd3386e243d16b6e374"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65d487759bf87cfa37b18dc486ffa928296813d2e0aea8336e20c09d105be602"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8910a07bc5ef5d513e7582dff60e41094c869565b3f4ea6014b42e0395b8c80c"
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
