class Ranger < Formula
  desc "File browser"
  homepage "https://ranger.github.io"
  url "https://ranger.github.io/ranger-1.9.0.tar.gz"
  sha256 "64ba1eecee54dce0265c36eb87edaf4211a462dc0cb6c831113a232829fecfd9"
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
