class Ranger < Formula
  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.2.tar.gz"
  sha256 "0e1d1b1d3f78c227a6cfa783822e98591ca76a35c643d4814f40f73515d66b8a"
  head "https://github.com/ranger/ranger.git"

  bottle :unneeded

  def install
    man1.install "doc/ranger.1"
    libexec.install "ranger.py", "ranger"
    bin.install_symlink libexec+"ranger.py" => "ranger"
    doc.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("script -q /dev/null #{bin}/ranger --version")
  end
end
