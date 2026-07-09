class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "08b8135f6dce18be6016046aa8e75607e998f4f4687154f7d9ebb1bb03666756"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac32e48ca74bcefb89230f3423c76289dbd053f40bd161177b1b4e1424c7a77e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac32e48ca74bcefb89230f3423c76289dbd053f40bd161177b1b4e1424c7a77e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac32e48ca74bcefb89230f3423c76289dbd053f40bd161177b1b4e1424c7a77e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d8ae05b7227ef1ae13a7ee2ea28efe7bfc87600a09b4f6158d9e3747729cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "006b94b43f8535d475c386db733ea8738080cd91e58687b88e055cfddcc00e9a"
    sha256 cellar: :any,                 x86_64_linux:  "d47193757b819f58ef6b1a88a05154f181c05e147ec1412beb524f4fbf08f249"
  end

  depends_on "go"

  def install
    # The top-level go.work only lists v3, so disable workspace mode to build v2.
    ENV["GOWORK"] = "off"
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
