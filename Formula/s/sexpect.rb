class Sexpect < Formula
  desc "Expect for shells"
  homepage "https://github.com/clarkwang/sexpect"
  url "https://github.com/clarkwang/sexpect/archive/refs/tags/v2.3.15.tar.gz"
  sha256 "44f5711aa99f3ccf9c4b0edfcd9a7d25fa64b442574624ce451713d1532c1a7e"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "445597fc095ce9f21e20e79f2d242e487649d56eed1b27f362250aa74111b227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8647d681a0db2c3a76b9b22182564a560f630709d1bf9313740968ad9090ffb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfb2baed2c6a89e7bb6c7c7d3e3fde11b3638e3a2c9e015d9fe0fc4f8d32589f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7858fbb1d10b1879cf855315dd723a2273c31e2aa8c95150860f25c5f4d71989"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9a3b88e131cb425f9e061af99304e882540035f88e595cf7d5791a03af6860f"
    sha256 cellar: :any_skip_relocation, ventura:       "46426d997a36dcd97a5b39ad3710b5aa14302fa95c8d223eebf126f3a5d212c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0702807c75c5500cc19564fdc28623f5f5118d61462e22bf423e470e1691879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d83044609dd02ec1d1ae82b2bf3af77038ed6868792d1e79adb3599c52ad4e31"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sexpect --version")

    (testpath/"test.sh").write <<~SHELL
      #!/bin/sh

      export SEXPECT_SOCKFILE="#{testpath}/s.sock"

      sexpect sp -t 10 sleep 60
      sexpect c
      sexpect c
      sexpect c
      sexpect c
      sexpect ex -t 1 -eof
      sexpect w

      [ $? -eq 129 ]
    SHELL

    system "sh", "#{testpath}/test.sh"
  end
end
