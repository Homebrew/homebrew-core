class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "d98866b5f7a2e2378a3cc5ca76422bcef27d669bbe1dd5792a35db2589262e1f"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(:?\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0be646f0154dd387fec816f162703b117730ae6d3a39abce08e58acf97ec364f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "147319c9b2bba0e960bae4cc69c4fef9cd3019d9a33d3435f3deb9742c963d61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d2278b38796ea5d7f62a446ad6f2316b6ddf580fb201653a27142d934e037f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85067d82fd8cb6caa4b3d55b2c42bd9893171606fa7f63ed52e3c666a27bbb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9ce0375c3fdc6b7a5d79a7c006600e9c37e4ddcb2532f53a82ca80ec5296b414"
  end

  depends_on "go"

  # Test scaffolds a project, which downloads Go modules
  allow_network_access! :test

  def fetch
    cd "v3" do
      system "go", "mod", "download"
    end
  end

  def install
    # Disable modules that require GTK
    ENV["CGO_ENABLED"] = "0" if OS.linux?
    cd "v3" do
      system "go", "build", *std_go_args, "./cmd/wails3"
    end
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}/wails init -n brewtest 2>&1")
    assert_match(/Name\s+brewtest/, output)
    assert_match(/Framework\s+Vanilla/, output)

    assert_path_exists testpath/"brewtest/go.mod"
    assert_match 'APP_NAME: "brewtest"', (testpath/"brewtest/Taskfile.yml").read

    assert_match version.to_s, shell_output("#{bin}/wails version 2>&1")
  end
end
