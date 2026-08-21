class Ski < Formula
  include Language::Python::Shebang

  desc "Evade the deadly Yeti on your jet-powered skis"
  homepage "http://catb.org/~esr/ski/"
  url "https://gitlab.com/esr/ski/-/archive/6.16/ski-6.16.tar.bz2"
  sha256 "49f97ef545c5ad0ef29ebeb2cc087a84de6764543325a9472df89792ea70d98f"
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
    sha256 cellar: :any_skip_relocation, all: "98a857570a3b6256fa5c54a790c7f688c0283df59cef730b59409d3ede94fa65"
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
