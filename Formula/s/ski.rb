class Ski < Formula
  include Language::Python::Shebang

  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "http://www.catb.org/~esr/ski/ski-6.15.tar.gz"
  sha256 "aaff38e0f6a2c789f2c1281871ecc4d3f4e9b14f938a6d3bf914b4285bbdb748"
  license "BSD-2-Clause"

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

  head do
    url "https://gitlab.com/esr/ski.git", branch: "master"
    depends_on "xmlto" => :build
  end

  uses_from_macos "python"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "make"
    end
    bin.install "ski"
    man6.install "ski.6"
  end

  test do
    assert_match "Bye!", pipe_output(bin/"ski", "")
  end
end
