class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e1915e192c78e53679995b042d152b6469ce43c785d104b8b15b36e63797b24e"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    manifest_sha256 "43800fbfa00d8cc94ad7f358f670f1496323e0d41b43a723504a96445dd5f8e5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "91a88e64ff40afea467f7fe9f3365c9848b0fe4efb88649a77d5058ee794db5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "91a88e64ff40afea467f7fe9f3365c9848b0fe4efb88649a77d5058ee794db5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91a88e64ff40afea467f7fe9f3365c9848b0fe4efb88649a77d5058ee794db5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a9addddf463ae6a6c2566323af9b3c385c642f98c6c27254fb15cd911168853"
    sha256 cellar: :any,                 x86_64_linux:      "d725dd5f939175f77945739924c694915d4192b5e7de35c06d4412e88d303a9d"
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
