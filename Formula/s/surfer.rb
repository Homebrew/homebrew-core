class Surfer < Formula
  desc "Waveform viewer, supporting VCD, FST, or GHW format"
  homepage "https://surfer-project.org/"
  url "https://gitlab.com/surfer-project/surfer.git",
      tag:      "v0.6.0",
      revision: "78e71f1e7761750a68fd94c128dd60ad00b220bc"
  license "EUPL-1.2"
  head "https://gitlab.com/surfer-project/surfer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6485e4d892bd9ad4b04bf855f99b0c8cbb1e185ab35e2b4db700341e904a0064"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d995b044bc208a2e1d2fba05ef2bb6aa2d9a8b489530df244f9f5be75cb5e23e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b97bb1fef3907a4a9521c2d32e598931459b85979438f40f9015b8e49c96360"
    sha256 cellar: :any_skip_relocation, sonoma:        "33e540772bc2a6bc1e743311ec91ae3f3aa77504c55c753cc1d4a160f66a6901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0cdb200ccd14bd20cb9b568eb02e183e10b07b3247990516e05d97bf564a1a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a9ddad60ff28fa2f1e4e7e4cc862c806b4a512d76ba5fd775fb48dc8d4a03e9"
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
