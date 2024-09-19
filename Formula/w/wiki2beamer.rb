class Wiki2beamer < Formula
  include Language::Python::Virtualenv

  desc "Create latex beamer code from an easy, wiki-like syntax"
  homepage "https://wiki2beamer.github.io"
  url "https://github.com/wiki2beamer/wiki2beamer/releases/tag/wiki2beamer-v0.10.0"
  sha256 "7fd4456c52b3d3f65c131e614b4805053a17ac4986bca3f5bbb1d747d69e6a8b"
  license "GPL-2.0-or-later"

  depends_on "python@3.12"
  depends_on "texlive"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wiki2beamer  --version")

    (testpath/"test.wiki").write <<~EOS
  ==== A simple frame ====

* with a funky
* bullet list
*# and two
*# numbered sub-items
    EOS
    assert_match "frametitle{A simple frame}", shell_output("#{bin}/wiki2beamer #{testpath}/test.wiki 2> /dev/null")
  end
end
