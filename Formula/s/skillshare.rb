class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "6bd6a0247a0cdd0097567d7bbb09205852e07a4dcf848b654e1869d6264b3c9f"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3a643e13814999ed0cba7b28ad996d301ae1a464829f7ab821af13ae825f1af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3a643e13814999ed0cba7b28ad996d301ae1a464829f7ab821af13ae825f1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3a643e13814999ed0cba7b28ad996d301ae1a464829f7ab821af13ae825f1af"
    sha256 cellar: :any_skip_relocation, sonoma:        "aad5a503317bc17875bd6a7f4b8c810604b999b8ed6eb0ace79acf3631152cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "540d6bbb6b9f56a88bea00613f51ed68abe496c3f7269fd6d52d7a6321ca832a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eaf0aee6953319f4be044c405d39bd772e565954e8267a5dfa23a1a634e11e9e"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
