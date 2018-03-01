class Titlecase < Formula
  desc "Script to convert text to title case"
  homepage "http://plasmasturm.org/code/titlecase/"
  url "https://github.com/ap/titlecase/archive/v1.003.tar.gz"
  sha256 "3eb87fe415a830386c344b0a8a25d7630bd5d9b15b662e00fe11f3adcb78635c"

  head "https://github.com/ap/titlecase.git"

  bottle :unneeded

  def install
    bin.install "titlecase"
  end

  test do
    (testpath/"test").write "homebrew"
    assert_equal "Homebrew\n", shell_output("#{bin}/titlecase test")
  end
end
