class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "d4273408c6eeeb9e69fe04e5d7400247502575841c79371dc680fc6b2e3aaaa8"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4bb33f0b28d7c5a0582927b1fbb47543dfc495af2f8ca6b8ac36585e6a061b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d016d52ab0e1fd1a47cbcd4175d16436f0fc148e0883ce021324ce5f149b4ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7284c7ab3e13f87e17c2ca36d4f52ac2a1fe9fff5a1182d50e88e3de2498ff59"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf9736a33684adcb7efeca52e55e01777f05927b4e5b97ae2fe2fbb882b297d"
    sha256 cellar: :any_skip_relocation, ventura:       "8094944b73a10f682b0b915b8f4978490cc895f237d1c40e3e2794f6ad07d35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbf3866c7396c20b2684c1883edf264c2ad8df5eaf9b8e9ba02f7f07ca8df4f0"
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
