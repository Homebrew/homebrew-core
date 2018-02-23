class Ranger < Formula
  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.1.tar.gz"
  sha256 "40411b0dd08b0abd2632399751b111359786ae5f1e6df047f49653cb7a9edfd2"
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
