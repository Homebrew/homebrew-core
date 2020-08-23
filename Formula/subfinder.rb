class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.1.tar.gz"
  sha256 "bb5cee73d754cb92729eb4c446fd6cda87b4709e4e32996f5eedae7cb1967dfc"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5be0e1ba5341b28e664ec92fd76a072a9c1cdc0cda604d7a09b9d1539ee21bcb" => :catalina
    sha256 "fb5b981f50794b69e0d30c5dc479ddbe431f08c2a0e4f2381b06159b6b490d60" => :mojave
    sha256 "47ae3e2e7f2645f16c963a43ec1bf57f3bf9afa25ebffb11fe6b85f540d52a72" => :high_sierra
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
