class Surfer < Formula
  desc "Waveform viewer, supporting VCD, FST, or GHW format"
  homepage "https://surfer-project.org/"
  url "https://gitlab.com/surfer-project/surfer.git",
      tag:      "v0.7.0",
      revision: "bd749b1f786c1c62cd67893ca71346cbe6983915"
  license "EUPL-1.2"
  head "https://gitlab.com/surfer-project/surfer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3ccd3b8def9247442b19ec02afd47579ed36daf5e21aa1602a24748af77c254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cc2a6fffbe2dacc7ac15a125f90e61565e03a71f45dec28b66cc8f69c06428e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71d186edcbdfb3f2caebcac11d052080144cf938fd395ed7135379210b9aaf95"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb5ddc4c85f303feeacedd67b53a9d23140147206c4ac37bf841296fe41fae66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc2e9c7066f7447868bb8a397bf5955ee1a2a6bee554dfbba20aed2efd3d94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ec6e93b0d0433555b594262c3eddf08886ec7c2263a0e312a0112805af36eb2"
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
