class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.37.tar.gz"
  sha256 "4fcb961586d8a6d98ac9343ca5647421b98fdc79b51d81a1d3d18576b7908823"
  revision 1
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df293a2b797a034bfad0f70ceea4224c7ebf4c3bb9dc5f4c00b7e7f660dd9872" => :mojave
    sha256 "2b7a9141c9bdf1f81504ef26d6f5d8a406960a80524e161ac72511c02d80053f" => :high_sierra
    sha256 "034447e6f32a3c4925682911e97a89d62ca418347ad0be425a64d299db1f7f20" => :sierra
  end

  depends_on "python"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
