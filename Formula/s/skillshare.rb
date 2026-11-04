class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.28.4.tar.gz"
  sha256 "137205a6d19a9ec7422ca912892bcbf6fbf0c3838c74314d78a786b4163dc589"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fbe6da49ba8f184dba38d3afca2dd133cb4af57c0d52b77c06ca0d0863c2dfa6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbe6da49ba8f184dba38d3afca2dd133cb4af57c0d52b77c06ca0d0863c2dfa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fbe6da49ba8f184dba38d3afca2dd133cb4af57c0d52b77c06ca0d0863c2dfa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3fbaee92d81dbf52fc722cbca367683b9945eb7cf44e8434adf1932ad66aa4e2"
    sha256 cellar: :any,                 x86_64_linux:      "542f385cd3e86015ca2ddb07994c09189c5998015bb1ecfe1796691ee44f0678"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
