class Taskopen < Formula
  desc "Tool for taking notes and open urls with taskwarrior"
  homepage "https://github.com/jschlatow/taskopen"
  url "https://github.com/jschlatow/taskopen/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "249cce42ac427376a8909e81e49f2d2ba0e79d29b9f83224560cb45df8b7d31c"
  license "GPL-2.0-only"
  head "https://github.com/jschlatow/taskopen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba5315263677626560719cf9b4936356ea4e097211a40863d8ce055e09f0dada"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f5c99069492f89ba1914486b47319087cadb8cfdf6f01ee6916e54253ca18c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9d13f19de0ae93c8fb39013f97cf6f15746119abfa12dad2b3bf32c0d71960d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2655a0cca3da272aafa320a8ba8e194db08bb9b43fa8beb8c8c5fde23cafca73"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fdaabc629647d5636b4546ef9f9ba9eb0c2a7302757b35fbc17ab515e8a508a"
    sha256 cellar: :any_skip_relocation, ventura:       "1d74f583708153e1e0ba9887a202c9213c8c67920ada59ac846aa32ed284544f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1fd23bf1717a925c9a112ca24740edecc4087709e05c577837cced58948994a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7f9a63cc6b29145c0539b67631464262aaf2088de11d9fe071060bdd500da2"
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
