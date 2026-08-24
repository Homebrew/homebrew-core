class Sexpect < Formula
  desc "Expect for shells"
  homepage "https://github.com/clarkwang/sexpect"
  url "https://github.com/clarkwang/sexpect/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "8f7a989ecf67f4ff6eb167d29a8e2e54db85143ebf3e8f904ea16ee5576a4b0d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69d2d2d4905013f26bc6e74a74963c07dffb0f816e508b70a4f147158980645a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3fd7a08ec1d5133e29c9a6743c9a7164b877a1b92e3f3e4c0a67f07ac7225a12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b90c0771c703618e4c4ff10dd443bd8438e245e99d3eb0480e0f7ace0a8ec57f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0361e92cae81fbd78763f1b1d6046610fa69dbee811bc3e432b3f9b1d4510578"
    sha256 cellar: :any,                 arm64_linux:   "3203c810fc26b46c089f0ce70b10db8a41a2b518126e0e2993ba0e3580a926c4"
    sha256 cellar: :any,                 x86_64_linux:  "9545c84738e53aa093caa9a3823b57d7a75a11b19674f2b396e05df81a53a41a"
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

    system "sh", testpath/"test.sh"
  end
end
