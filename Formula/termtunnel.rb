class Termtunnel < Formula
  desc "Cross-platform terminal tunnel tool"
  homepage "https://github.com/beordle/termtunnel"
  url "https://github.com/beordle/termtunnel/archive/refs/tags/version-1.7.2.tar.gz"
  sha256 "cd4d7b02bbae8a992f839b3d699923b0af4425ca5b2af6207e7f130fd18f1c8b"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "."
    system "make"
    bin.install "termtunnel"
  end

  test do
    shell_output "#{bin}/termtunnel"
    assert_equal "", shell_output("#{bin}/termtunnel sleep 1")
  end
end
