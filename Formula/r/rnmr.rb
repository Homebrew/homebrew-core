class Rnmr < Formula
  desc "Lightweight command-line tool for renaming files and directories"
  homepage "https://github.com/moealkurdi/rnmr"
  url "https://github.com/moealkurdi/rnmr/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "1de434586d7cefac1a76b31af56c485a69bd4689bbe90e3aa8b60346aab16860"
  license "MIT"

  depends_on "python@3.11"

  def install
    bin.install "rnmr.py" => "rnmr"
  end

  test do
    (testpath/"test.txt").write("test")
    system "#{bin}/rnmr", "test.txt", "renamed.txt"
    assert_predicate testpath/"renamed.txt", :exist?
  end
end
