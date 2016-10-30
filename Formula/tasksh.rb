class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  url "https://taskwarrior.org/download/tasksh-1.0.0.tar.gz"
  sha256 "9accc81f5ae3a985e33be728d56aba0401889d21f856cd94734d73c221bf8652"
  head "https://git.tasktools.org/scm/ex/tasksh.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "78f4218db1fd17a5a89fda4982e2054e2f283d4a2a24a431fd94126a07e8fd99" => :sierra
    sha256 "74593fb90941d65acd8a4712218c2285819cbd61916b24be3ea792abbbe4dee5" => :el_capitan
    sha256 "a618c8e5a8bf535aa116b60a68579f6f41904169641f43dde82693355785b38c" => :yosemite
    sha256 "d3a214c7e1dd43755ad6a0e77bf9d1a455f88c67b60126f1a9f64b9bf426bfdc" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "task" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/tasksh", "--version"
    (testpath/".taskrc").write "data.location=#{testpath}/.task\n"
    assert_match(/Created task 1./, pipe_output("#{bin}/tasksh", "add Test Task"))
  end
end
