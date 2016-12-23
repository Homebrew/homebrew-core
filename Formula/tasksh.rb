class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://tasktools.org/projects/tasksh.html"
  head "https://git.tasktools.org/scm/ex/tasksh.git", :branch => "1.2.0"

  stable do
    url "https://taskwarrior.org/download/tasksh-1.1.0.tar.gz"
    sha256 "eef7c6677d6291b1c0e13595e8c9606d7f8dc1060d197a0d088cc1fddcb70024"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/71c6658/tasksh/tasksh-1.1.0-fix-hang.patch"
      sha256 "02011f7cf6d2e74ba716a8e87d53a5e26986d75f4a39c69eb406c3c85b551e8b"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f4fbdfe7e82a50bce8b9bb9b1455ed4928ab32ebfbb185d5bb6bba1e6dacd1c0" => :sierra
    sha256 "0daecc2a8478e84ee4e84dc7bbca8888341ab021fa5f9379416862c28c2d1eb4" => :el_capitan
    sha256 "09895c7c1a3da30eb510fe971854af62d31dcd57c08dd8f60a4556b9273ad237" => :yosemite
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
