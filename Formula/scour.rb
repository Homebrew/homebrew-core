class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://files.pythonhosted.org/packages/75/19/f519ef8aa2f379935a44212c5744e2b3a46173bf04e0110fb7f4af4028c9/scour-0.38.2.tar.gz"
  sha256 "6881ec26660c130c5ecd996ac6f6b03939dd574198f50773f2508b81a68e0daf"
  license "Apache-2.0"
  revision 1
  version_scheme 1
  head "https://github.com/scour-project/scour.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "281cc65233bf8de758ea2a034b28ac6f062731fd5777f0039c302ce6b0a9be9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "281cc65233bf8de758ea2a034b28ac6f062731fd5777f0039c302ce6b0a9be9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "281cc65233bf8de758ea2a034b28ac6f062731fd5777f0039c302ce6b0a9be9f"
    sha256 cellar: :any_skip_relocation, ventura:        "e9a2c2597476cc5d8b127fa7c7d6b6ec086ad922b1098e9635140d107b0aca16"
    sha256 cellar: :any_skip_relocation, monterey:       "e9a2c2597476cc5d8b127fa7c7d6b6ec086ad922b1098e9635140d107b0aca16"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9a2c2597476cc5d8b127fa7c7d6b6ec086ad922b1098e9635140d107b0aca16"
    sha256 cellar: :any_skip_relocation, catalina:       "e9a2c2597476cc5d8b127fa7c7d6b6ec086ad922b1098e9635140d107b0aca16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e19831a0e171a39afba264fb8dec3ffbb825a9c6128c0ecf406f939253dd9f6"
  end

  depends_on "python@3.11"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
