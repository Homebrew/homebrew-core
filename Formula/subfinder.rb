class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.5.tar.gz"
  sha256 "1adbd9c180f7ca6378796748491e23a808e423268bc61fe63af0206877f0ba68"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0605119e8efcf7a6ea237665fae5b5bda1715b9844921b3fc0bcd9d67af5013" => :catalina
    sha256 "61061910e7fbaf2223c06791704c021adc8df0dd96643803decfc55be305f8e4" => :mojave
    sha256 "46398f2facb9cf9c2143d0841f5c9293aa98c63667e2470ffd999ade3cc8af0d" => :high_sierra
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
