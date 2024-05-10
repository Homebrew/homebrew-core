class Taskopen < Formula
  desc "Tool for taking notes and open urls with taskwarrior"
  homepage "https://github.com/jschlatow/taskopen"
  url "https://github.com/jschlatow/taskopen/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "d6749ff4933393d2b4f7e9e222c19ba3cea546e4e74bdc96c7e4a31a76fd7861"
  license "GPL-2.0-only"
  head "https://github.com/jschlatow/taskopen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04d6f502161c71985dff812e6982066a9e7c01598db1e2c5369289ef583b4d79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "000cc5761a934d64c4898c38f12af4268d6b9e4ae4378a18f32e149d99d7b7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c09373978bc107c459f01089e5b077ba52f1d0e8ea536358d66936e2bc335b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5b2b331014ff8389a4de1583532276ee67c8d7d9cba3d2c893afc71c0e50db3"
    sha256 cellar: :any_skip_relocation, ventura:        "ec7a107ad125ab7bffe3741676c3830aa298fba8af48be31c709044068380e95"
    sha256 cellar: :any_skip_relocation, monterey:       "7342cd21d4b7db947d0edfd896f3bacd9d1843dc9658682937034b16ad5f9dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f441e77e29f47176276825a3b92a2832a3628311f73cd8c237eaf3a03cae3af"
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
