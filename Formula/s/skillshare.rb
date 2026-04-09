class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.18.9.tar.gz"
  sha256 "a48ea70c714527a8bc6320e0eb55c934cd92b8eb603a8f28486bf2a182420472"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d73f74cc42f19bd3db6a7f7b1e82d42fd83bfea8eda2a05bd56517dd97c0284"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d73f74cc42f19bd3db6a7f7b1e82d42fd83bfea8eda2a05bd56517dd97c0284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d73f74cc42f19bd3db6a7f7b1e82d42fd83bfea8eda2a05bd56517dd97c0284"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1dc9f1e3fafeb3f02ca8b5262d7193f11dae15b5cb572c9db78b29d4e457cee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b43c102623f2b357c29ea1ab44f13d23c1ed5de974e7c2a7895ac2e8015b5f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d838c770ba2ca2fea71ff2589330141b8ff635336e1e9a9f88f314a87671779"
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
