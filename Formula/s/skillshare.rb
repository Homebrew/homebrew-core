class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.22.tar.gz"
  sha256 "13bcaa3a47a6c2edb4c9d4285ddf8ca6276fafaa8935aa483d0c8771b0649fe6"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0c0103ba3aa34398eb75d9ff957fe5bfc140266b772fc2f7e9c6e5cdad22165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c0103ba3aa34398eb75d9ff957fe5bfc140266b772fc2f7e9c6e5cdad22165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0c0103ba3aa34398eb75d9ff957fe5bfc140266b772fc2f7e9c6e5cdad22165"
    sha256 cellar: :any_skip_relocation, sonoma:        "322a39d437432a3fb420f4528fb51a3e838ff7df04bd3bdeb45ecb1a230b1ee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc27b8c559670f3b4102a55964a4f049b0553754e866de3104831c382ff9afed"
    sha256 cellar: :any,                 x86_64_linux:  "68b9679529e39c8c1f1516935364540a96352fac0251aca6a2b51683dd059397"
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
