class Romlm < Formula
  desc "ROMs library management tool"
  homepage "https://github.com/ManeFunction/romlm"
  url "https://github.com/ManeFunction/romlm/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "e9922e3edc16aef9d46da52c415deb31371cefd05a3f36fb9e94be5e7be9d80c"
  license "MIT"

  depends_on "python@3.12"

  def install
    system "pip", "install", ".", "--prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/romlm -v")
    assert_match "ROMs Library Manager v#{version}", output
  end
end
