class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "864b53f22ca98ed17e456b352ec4691cfc2105bdcb23e87df8f826035b08d8c0"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f98b0a5d0c15753a4410eb2580d4b663b8c91862d873af5789ccc0c9296be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f98b0a5d0c15753a4410eb2580d4b663b8c91862d873af5789ccc0c9296be9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6f98b0a5d0c15753a4410eb2580d4b663b8c91862d873af5789ccc0c9296be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0cca6feb3ce022ff0875c747eb3440925aa672dda5b791bf7515e161f6354fc"
    sha256 cellar: :any_skip_relocation, ventura:       "e0cca6feb3ce022ff0875c747eb3440925aa672dda5b791bf7515e161f6354fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "199bb21c9f41e82c78e3b5c50c9ebe71bec297615d91deb6c323bfc8c8e47510"
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
