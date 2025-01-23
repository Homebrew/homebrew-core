class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "7bf572b89dd6b60d679073dcdda34b4c0f506ebfe7278337488eac13d15e1297"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c318f209b29ade6c47b70659b7b77ff554d00fc3a72e058aafdf2c70bf2fd69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c318f209b29ade6c47b70659b7b77ff554d00fc3a72e058aafdf2c70bf2fd69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c318f209b29ade6c47b70659b7b77ff554d00fc3a72e058aafdf2c70bf2fd69"
    sha256 cellar: :any_skip_relocation, sonoma:        "db2167edf63983527170911be8f10b7d853cffb4eef8f73409f392b5d8fd920f"
    sha256 cellar: :any_skip_relocation, ventura:       "db2167edf63983527170911be8f10b7d853cffb4eef8f73409f392b5d8fd920f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcfa9c1d10634eede184b8d1ee188646bad5786c99a74d947ca03df0521ddab1"
  end

  depends_on "go"

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/wails"
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
