class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://gothenburgbitfactory.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.2.0.tar.gz"
  sha256 "6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/taskshell.git", branch: "1.3.0"

  # We check the upstream Git repository tags because the first-party download
  # page doesn't list tasksh releases.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "987789014e770fb3b4b1d4500321877c457ba2a1dde2fc9925762dfb0d7da541" => :big_sur
    sha256 "590c43b791080cc6ca56cef896c9e75a8ca77915b061a1d0a711a0489e69ab63" => :arm64_big_sur
    sha256 "68a13aa8ea81fd1fe7c2c5e9eadd3850fe21265b34c4cf2f1cf7e7ede3caeaee" => :catalina
    sha256 "a2178acd290abac6dc8c024b48304c05660616639c7de1c7b35eb166ae8345dc" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "task"

  on_linux do
    depends_on "readline"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/tasksh", "--version"
    (testpath/".taskrc").write "data.location=#{testpath}/.task\n"
    assert_match "Created task 1.", pipe_output("#{bin}/tasksh", "add Test Task", 0)
  end
end
