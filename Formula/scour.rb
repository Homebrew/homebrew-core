class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.37.tar.gz"
  sha256 "4fcb961586d8a6d98ac9343ca5647421b98fdc79b51d81a1d3d18576b7908823"
  revision 3
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03bac92a88319ff21d807b0d7438284b299262003b592987b38dda5a49389e48" => :catalina
    sha256 "927a6beeb623f29806e592eed6e2e3ee99861bc946bc24d5fd711dab50c29d15" => :mojave
    sha256 "4c5956feecd0b017e5165a4602d3d42ef4403141f35280fd1e4a0bc2369b69ea" => :high_sierra
  end

  depends_on "python@3.8"

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
