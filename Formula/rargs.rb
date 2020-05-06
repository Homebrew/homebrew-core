class Rargs < Formula
  desc "Util like xargs + awk with pattern matching support"
  homepage "https://github.com/lotabout/rargs"
  url "https://github.com/lotabout/rargs/archive/v0.3.0.tar.gz"
  sha256 "22d9aa4368a0f9d1fd82391439d3aabf4ddfb24ad674a680d6407c9e22969da3"

  bottle do
    cellar :any_skip_relocation
    sha256 "89fe0e1d60e88b0ce966d31962adbe352af2bc1b6a45e66a8fc3783f80d90edc" => :catalina
    sha256 "2fb0c1a1c572c148027cc48bc8d66cc3a02ba0325648eee9c2b1dd20242cb083" => :mojave
    sha256 "e98e7b13fa8b875de0fe15ca7dbb6a8e2e5e4d0b38b75eab62342b8decc38f16" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_equal "abc", shell_output("echo abc,def | #{bin}/rargs -d, echo {1}").chomp
  end
end
