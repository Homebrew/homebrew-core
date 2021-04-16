class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.7.tar.gz"
  sha256 "86f8ab43a0d27481e57dfb8fad9bd5314a41a51d864191bf10a07ecfa4d1a2b8"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c66f8b11984d14a8d6b3024bab85533135ddc244d86ef210e3f9efc7859b2d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "2162b277d7ce772652a9e762cc0b39ffa71a39e7bc855d47da022e378b58b060"
    sha256 cellar: :any_skip_relocation, catalina:      "4e2388bd0c8596257b9413a2b4880b260bd17491140aeff6bb7a145514be8d8c"
    sha256 cellar: :any_skip_relocation, mojave:        "b4657d5d5f654c8e34c9425bf40fbc9b7debcebc22fe7516e7d437d2e442f17c"
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
