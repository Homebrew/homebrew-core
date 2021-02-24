class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.6.tar.gz"
  sha256 "ab7b67d7e8f79b5f2afebdb45dea8cc90c166f7b4f256387e0917ff4b753ffcb"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc4bce48737f9738622f326651af48de8876f463eda8385a42381ee2c61f6ba2"
    sha256 cellar: :any_skip_relocation, big_sur:       "c6730bcaccc2f5111940fe68ebd54158a35cd715378307f00fe781ce7bcd9b79"
    sha256 cellar: :any_skip_relocation, catalina:      "c988222baa5ad827d1b9b80994791ea791ef72b889fc2d4a756724d0183599df"
    sha256 cellar: :any_skip_relocation, mojave:        "76ea1e018ea82afc7b7e9f083a5166037b245a73dd9147eae45e1981f18f3484"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
