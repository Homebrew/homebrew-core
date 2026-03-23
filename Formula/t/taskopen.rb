class Taskopen < Formula
  desc "Tool for taking notes and open urls with taskwarrior"
  homepage "https://github.com/jschlatow/taskopen"
  url "https://github.com/jschlatow/taskopen/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "fe16f839279e8baff96dcead55feb03997aebdaa3cee7a421dadc8e7cb8c1581"
  license "GPL-2.0-only"
  head "https://github.com/jschlatow/taskopen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88c6ca32bc458061057c90fa56237a7e0d0c7e7325a9b8f18e8750b6bb822b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5ad079b35dabb3834b719543b3f3ec64373cd538bf9920a8c801543f43c408a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ab00cba3ecabd049d3852c0dfed545462ccab1bce5072591eb4d27c5758071"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a0350d52c91cd2aa71a76feeb6197551d65a6eb3e9e2cd9150691742e0c6549"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "822855f8d7f1453c212863347f73a256b63f7939a9f32a03f6ff216816557d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c58603d593ac29b6893b614cdde533fac5c6c3271383303698081e11e9fdc364"
  end

  depends_on "nim" => :build
  depends_on "task"

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    touch testpath/".taskrc"
    touch testpath/".taskopenrc"

    system "task", "add", "BrewTest"
    system "task", "1", "annotate", "Notes"

    assert_match <<~EOS, shell_output("#{bin}/taskopen diagnostics")
      Taskopen:       #{version}
        Taskwarrior:    #{Formula["task"].version}
        Configuration:  #{testpath}/.taskopenrc
    EOS
  end
end
