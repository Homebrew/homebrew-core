class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.25.tar.gz"
  sha256 "43a590d718d11d9c6df0d622edfd6dbcf70b1a31ed6041b028ed514e0e4c55d4"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a648e1e4e616ebf47716d4f535c1bc99ad25bf33c469b8b84e073733dd7bfcad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a648e1e4e616ebf47716d4f535c1bc99ad25bf33c469b8b84e073733dd7bfcad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a648e1e4e616ebf47716d4f535c1bc99ad25bf33c469b8b84e073733dd7bfcad"
    sha256 cellar: :any_skip_relocation, sonoma:        "69330e6543db79cf6d6fd3f3018bfb75f334ffc032c0f82bc1361ea41f1995b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d309675aabb777921c0ca05f370ec6ba76afcd23c235253a9d31cc35f9b006c"
    sha256 cellar: :any,                 x86_64_linux:  "911ba46f1382ee341d3042381fd41ef1b97e7f7953e3c6749d7e16a5d072e85e"
  end

  depends_on "go" => :build

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
