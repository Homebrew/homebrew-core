class Sexpect < Formula
  desc "Expect for shells"
  homepage "https://github.com/clarkwang/sexpect"
  url "https://github.com/clarkwang/sexpect/archive/refs/tags/v2.3.14-cmake4.tar.gz"
  version "2.3.14-cmake4"
  sha256 "b542562149740c01c7f3c0e7af78d8fa5b8ab4d53d951f83108ec9643ed43120"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "905eadc826dc623273592fdc407c2d93c1dbaa7cbc48cfa20a687fc034df7af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb5b6a3adb768d1350c2042fc7894f8167b8b3a740b3b33040583c6bd3d99a5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80c7bd9c41392b083ffcdfd1535d7bf875203c5560aec4b766ea5742b92b6626"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0e217ae23067d383fcac310f301fba79a01a739cf6c844799d73d81890fd845"
    sha256 cellar: :any_skip_relocation, ventura:       "50abbeb01950ce35c19afdc4dcdee87157994155efbc8822f97c4312ddc8fefb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49e406f2f6e7e8ec9e7bc0d8c924199d666ae3b033240bd1af9acf3befa3bb52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b342aeaabdc2a4a4b86cdac1cf606fb8e50308b68087bf56330bdaa529cee66"
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
