class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.20.20.tar.gz"
  sha256 "407747ed34027fbd44f077a14292aa82dc3633beb1fa8d236d0a4568a47e4dd2"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b872a7b286b2f2b7f9aed9215022bc2aa7831f1cfd8dbc6eb1282ed90b1f736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b872a7b286b2f2b7f9aed9215022bc2aa7831f1cfd8dbc6eb1282ed90b1f736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b872a7b286b2f2b7f9aed9215022bc2aa7831f1cfd8dbc6eb1282ed90b1f736"
    sha256 cellar: :any_skip_relocation, sonoma:        "d62d7965d7ee8ac7d4a5af17ac5c14f9a029581cc72dfc44e7c08db2816a287a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b641db71ad68021dd4b92959be6287704fdde5ac5c1d792b0b1a0729f526081d"
    sha256 cellar: :any,                 x86_64_linux:  "688661ba774f9b938d1817d05b0f44c261296e5a5365dfa717ffcd5ede83c3b3"
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
