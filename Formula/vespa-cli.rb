class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https://vespa.ai"
  url "https://github.com/vespa-engine/vespa/archive/v8.86.28.tar.gz"
  sha256 "4c632fd54b92a40c8ce5c5d8cb0d709c359b0bb0b90f4995e80c8e074960060c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/\D*?(\d+(?:\.\d+)+)(?:-\d+)?["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88e7921169920f2eb18b6379cf4dd4339ee77a3e22078b231e11a57b058fcce6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45331927e2d62d1cb8a542b7a68858e286671f3eeffb2d4f1c80014bda95df43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21e7b386c4456015841b4fdef7b20d648e54ecf4cd19f0698931e641925d4e3c"
    sha256 cellar: :any_skip_relocation, monterey:       "d22451554ebccadb2decdded5205111dfc3b62b1c426bdb29f8a18c5304bb576"
    sha256 cellar: :any_skip_relocation, big_sur:        "6365fd6837d93267d64afdac5c6a92958b249bca5084a7a16bca87d3405c6b3c"
    sha256 cellar: :any_skip_relocation, catalina:       "38552d1480963912cbaf3769ce5a166b57eccdce2464fa2d0f68a6928f512fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4b4b23fa14692a4b7848a4c376ca8b5f4109d9e184bc15a47f2c911ccd76dda"
  end

  depends_on "go" => :build

  def install
    cd "client/go" do
      with_env(VERSION: version.to_s) do
        system "make", "all", "manpages"
      end
      bin.install "bin/vespa"
      man1.install Dir["share/man/man1/vespa*.1"]
      generate_completions_from_executable(bin/"vespa", "completion", base_name: "vespa")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}/vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    assert_match "Error: Request failed", shell_output("#{bin}/vespa document get #{doc_id} 2>&1", 1)
    system "#{bin}/vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}/vespa config get target")
  end
end
