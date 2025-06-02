class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "11ddc1113ba6bfc6db1aeb8bdd97908ceed230e3e4911e9a6905c35f0795b2e2"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4012761b996c13be98b253acf2c97d9a0f56e6f090878c236b50d24334de427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f1e29abdec31a55472ee3e056a4b1d2234a50006ebf4078f8699ad8ea6ad781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b35928fb4541fd5e914ca969111b451289e8354c66addfd4d84301736baa1b2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e0b98643729a615d017bf3bbd687dec08f2ff7d0baa890f5595f096fb888ff3"
    sha256 cellar: :any_skip_relocation, ventura:       "b05b08f4b8b6a8ba8c5739c5140db0140fc7fa582f70678d91aef4b458fd72b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63927484b1657c52e52e9ac6d035d3461832ce40b0b959e9125c7b599c991ef5"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/subfinder/config.yaml"
      assert_path_exists testpath/"Library/Application Support/subfinder/provider-config.yaml"
    else
      assert_path_exists testpath/".config/subfinder/config.yaml"
      assert_path_exists testpath/".config/subfinder/provider-config.yaml"
    end

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
