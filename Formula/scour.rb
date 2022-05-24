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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a19de3b6e7507c4472d6807f651ba1dc9364091db38bf495964f1bc8aea5eca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a19de3b6e7507c4472d6807f651ba1dc9364091db38bf495964f1bc8aea5eca"
    sha256 cellar: :any_skip_relocation, monterey:       "f4540d61288bd5dc596393a3d87870d1aad8fe61771379b9fa98a564fc239a71"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4540d61288bd5dc596393a3d87870d1aad8fe61771379b9fa98a564fc239a71"
    sha256 cellar: :any_skip_relocation, catalina:       "f4540d61288bd5dc596393a3d87870d1aad8fe61771379b9fa98a564fc239a71"
    sha256 cellar: :any_skip_relocation, mojave:         "f4540d61288bd5dc596393a3d87870d1aad8fe61771379b9fa98a564fc239a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1d4f9a36356337522bfcc13866638b977ac217d2602aee271c152b60aa3cd62"
  end

  depends_on "python@3.10"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
