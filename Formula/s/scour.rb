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
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c688e78760b8c8f87118d0127b79c47886abe8288f8451365e3a59a0c7377703"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a533ea0ee18870e2e145fd1bbb99ca77805b54ab4b271e518852167ad90df855"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a023338435bb50e0c6ccc4518a9662d61c1fdb8d8321e30ef69f80254d34d005"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a77607761ae0a822ae2c604967ee564a4a3742b3ebd383b616c848241aba8de"
    sha256 cellar: :any_skip_relocation, ventura:        "8ab4b60f52781665c73102c1b06929463962340550fd5586456e62b517522ea5"
    sha256 cellar: :any_skip_relocation, monterey:       "619e1bfd3cfe889adcb3c5f3bee930b07ba48f06d19ecad387b9b35c39e6ab92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa73fafa8bc987a621e1654972c49c6c15afd3db53f87994ff2aca7946a6844d"
  end

  depends_on "python@3.12"
  depends_on "six"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
