class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "dbd90b0edbf972078fe5daac06082b554ce7578763462d8ec1056bddba4f2ca1"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05fb19bddb95d816fddd628dddab7f1ab36947b35a455c741e3c0c330e913790"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05fb19bddb95d816fddd628dddab7f1ab36947b35a455c741e3c0c330e913790"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05fb19bddb95d816fddd628dddab7f1ab36947b35a455c741e3c0c330e913790"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2ccfe653882fd166921860b0c59546dea2d86f48732634a397d098cd70d4b230"
    sha256 cellar: :any,                 x86_64_linux:      "64f57bbe403abbc5e3307f545077d036b66559e34fcde4d7521895bfb80f997a"
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
