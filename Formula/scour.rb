class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.37.tar.gz"
  sha256 "4fcb961586d8a6d98ac9343ca5647421b98fdc79b51d81a1d3d18576b7908823"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19ad78d7432ab304f132fc35713b6fb1c930adfd245a55693f932fc460ee00f4" => :high_sierra
    sha256 "6f38d0966f43d293688b66ea4fd518e0c03f8aa2f9aef66940f86b319aa3fbc5" => :sierra
    sha256 "26b5885d3e21030da63a640e044ef553d0ec8828a15cbeac9a19eaaab00be637" => :el_capitan
    sha256 "cf80be6ef39cbcdb2e4944799442f0d5fa2a76295fb54eae8677de6b72c8626d" => :yosemite
  end

  depends_on "python@2"

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
