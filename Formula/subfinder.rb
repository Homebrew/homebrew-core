class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.6.0.tar.gz"
  sha256 "a98dc92135ff462aa9e99f3bdfe079a14849c9f926028a7bb44af591ed18aa21"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0326291bfeaaa222aecf04a28bbae9b493f933ab3318cd9922e7ab96a0138293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0326291bfeaaa222aecf04a28bbae9b493f933ab3318cd9922e7ab96a0138293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0326291bfeaaa222aecf04a28bbae9b493f933ab3318cd9922e7ab96a0138293"
    sha256 cellar: :any_skip_relocation, ventura:        "bd4fb957fcbe8a1d63e8a81af4d85baa2a8563bdc6b25185f4335e376f64d806"
    sha256 cellar: :any_skip_relocation, monterey:       "bd4fb957fcbe8a1d63e8a81af4d85baa2a8563bdc6b25185f4335e376f64d806"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd4fb957fcbe8a1d63e8a81af4d85baa2a8563bdc6b25185f4335e376f64d806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24607d752fd4eb579f6ba1ded1b71ec29d23115cf330ba00ffd363538a813977"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")
    assert_predicate testpath/".config/subfinder/config.yaml", :exist?
  end
end
