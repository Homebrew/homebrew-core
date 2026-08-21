class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "4c865cbd5ab81401cf4557e54dfe517efc90d29980ccdaa54178b426fdd6d4a3"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5eab148839191d87a163c1ad5eeca7258e3acca5b1df034e57826552fbb5e62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5eab148839191d87a163c1ad5eeca7258e3acca5b1df034e57826552fbb5e62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5eab148839191d87a163c1ad5eeca7258e3acca5b1df034e57826552fbb5e62"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d4be922e46a7ac09e69cd7eceed7ef36500e7e2522076f6f5ce520c65803cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54e2ac22637a88ee8cae8d49cea730202eaeb969e27d57fd9eb11428f55fbf7f"
    sha256 cellar: :any,                 x86_64_linux:  "9029c77c6e45f8bac90ce565ecb76a2c2a77e9bca950d378328f358b66628f23"
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
