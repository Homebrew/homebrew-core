class Ski < Formula
  include Language::Python::Shebang

  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "https://gitlab.com/esr/ski/-/archive/6.15/ski-6.15.tar.bz2"
  sha256 "390e13ebc84a49d956a17d9e8842e78666e5718f12b7256c42fe7842fdddf664"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/ski.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14141d2ba391efd4932d5c119c2429abb66f8ef243bc0b22fcf9b71f717be9aa"
  end

  depends_on "asciidoctor" => :build

  uses_from_macos "python"

  def install
    system "make"
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output(bin/"ski", "", 0)
  end
end
