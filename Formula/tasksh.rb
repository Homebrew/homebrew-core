class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  head "https://git.tasktools.org/scm/ex/tasksh.git", :branch => "1.2.0"

  stable do
    url "https://taskwarrior.org/download/tasksh-1.2.0.tar.gz"
    sha256 "6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd"
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
    assert_match "Created task 1.", pipe_output("#{bin}/tasksh", "add Test Task", 0)
  end
end
