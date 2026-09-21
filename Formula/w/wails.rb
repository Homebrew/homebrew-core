class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "52f77b4dd53482e405d91fc42b587f6216b4f0beedb9ee919462e36357f10e3b"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8c64e4159f332a99fe9895f9726aa82e679f49e9e4447d044f772d05f10905d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8c64e4159f332a99fe9895f9726aa82e679f49e9e4447d044f772d05f10905d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c64e4159f332a99fe9895f9726aa82e679f49e9e4447d044f772d05f10905d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "255501c2e01fd5b34c25e7481a87275c2bd8a2ee25f77db3cfbaa1124e4c2f93"
    sha256 cellar: :any,                 x86_64_linux:      "424082a0f708d295e4751d4f560b8fc96d8eab75aabe579c1057a7a6a463c9b3"
  end

  depends_on "go"

  def install
    # The top-level go.work only lists v3, so disable workspace mode to build v2.
    ENV["GOWORK"] = "off"
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/wails"
    end
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}/wails init -n brewtest 2>&1")
    assert_match "# Initialising Project 'brewtest'", output
    assert_match "Template          | Vanilla + Vite", output

    assert_path_exists testpath/"brewtest/go.mod"
    assert_equal "brewtest", JSON.parse((testpath/"brewtest/wails.json").read)["name"]

    assert_match version.to_s, shell_output("#{bin}/wails version")
  end
end
