class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.4.8.tar.gz"
  sha256 "0e97f8a7bf48dc247af3dcac7bae67c1cb514b055fbcfb164a5190a484b0492c"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54279ba72b52aebf1aea25b02cba294a79a8bea56bb98312b8ea69e09de1ed0b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6caece489765bc37f6164278c96d5ef2a6bf081a3e70d0e9513d4dba803cda9f"
    sha256 cellar: :any_skip_relocation, catalina:      "88cab330e3cfb8325a8d295c512598670f626408e7a90520605f684c20089e06"
    sha256 cellar: :any_skip_relocation, mojave:        "35a8328f2fdc17c610ab78cf29dca7ef13a5cc77c6547983c1e81abdd6dcb939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0443b0e2d76ee7252666a214cc498d9050dc63c8bdcfc05bcfd5e50eaca43bee"
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
