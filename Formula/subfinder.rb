class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.2.tar.gz"
  sha256 "5a98284a509f848934019e2152ac93b9cb1a5cc8613e3346df79ed80f2045260"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "24783d440b8af36b7cae85d60ea382fe9455f5730b2859a766b22d8e093d9c33" => :catalina
    sha256 "d0cea688610125a9f8c9c119ce1c22b2be0cbefc0a03f8160abf64fc4a556409" => :mojave
    sha256 "6e7d36487ff9e2bdfa84cf033abd48f45eae34e51c78ef4a8825d0944d02e9c0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/subfinder"
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
