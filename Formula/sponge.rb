class Sponge < Formula
  desc "Soak up standard input and write to a file"
  homepage "https://joeyh.name/code/moreutils/"
  url "https://git.joeyh.name/index.cgi/moreutils.git/snapshot/moreutils-0.63.tar.gz"
  sha256 "4fc86d56a8a276a0cec71cdabda5ccca50c7a44a2a1ccd888476741d1ce6831d"
  license "GPL-2.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "b77ba5818bf53f3e864592820af2277c00b8e371b1ffb478b33edc78f9343993" => :catalina
    sha256 "0d651d015389d46adb0d91d4dba2fab77ad75a53af1979ce6e7f254e6dd7b941" => :mojave
    sha256 "bfbb4be2239ab1e181d8e671e940c42d55784facb6ca9734e1d8569ede665c00" => :high_sierra
  end

  conflicts_with "moreutils", because: "both install a `sponge` executable"

  def install
    system "make", "sponge"
    bin.install "sponge"
  end

  test do
    file = testpath/"sponge-test.txt"
    file.write("c\nb\na\n")
    system "sort #{file} | #{bin/"sponge"} #{file}"
    assert_equal "a\nb\nc\n", File.read(file)
  end
end
