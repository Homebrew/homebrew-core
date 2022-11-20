class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/v2.5.5.tar.gz"
  sha256 "78d081c56038de4ba743878b47964d3dea8c87c5c0e791456cab0b090869e833"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a64db5b4a8d7b1761fb2f878e88e22e2a095617c15b4e810adddf14e9ab53927"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61364f108d1fb6e4d491b56bbfc735ca6d786f266afa45bb10e1fb248b1c5b69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3aa3e50b0ac47568522c198cf6a84f2229bcb7386001bb685827dc64b5b497b"
    sha256 cellar: :any_skip_relocation, ventura:        "29a4429dc3ac673c1a578de4b6f7988debfb6501672fd79f2fbe83bec25050b9"
    sha256 cellar: :any_skip_relocation, monterey:       "f5b1f147beb4e483166c7b4890b7e62735ba6ae34be703637a65ea9513dcb36c"
    sha256 cellar: :any_skip_relocation, big_sur:        "37a62fa01039ca95dcde1449134affb721307f38c65474f2ac09ef2a7fa52ba8"
    sha256 cellar: :any_skip_relocation, catalina:       "045d934c8a61d31a234aafe8fba0b7e0e5ef587bac3e6b2fc90c75f543a88b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c88edcb86dc7e122074f6e3f39f8714c63df86bbc397542d6db26ad17e40c4e"
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
