class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.3.7.tar.gz"
  sha256 "4e87bdcdd1560557aa5cf6b1e2ef7a71c62fae218a8c81c2fa8849c476becfe5"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "09dc0347f7b7cc454903abcea0e962289d4dd11c5a4bb067c8c454855d9db25d" => :catalina
    sha256 "0820be0f2658e42671c63d223c780c61eb49bbf246455d382d89de7c615b0bea" => :mojave
    sha256 "b18f4004c01b54e5c0f0c07ec5efbfe581cdef10e8fe72ffe8968284579e5052" => :high_sierra
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
