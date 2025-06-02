class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "b070be6f9ac1e74f748cf68acc4a774d4f392d4a0992ea4967c73d4990b8b43f"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eedfb70909484e5c4da70504dbcaa205bfef6216b7375ad6331a117f64855d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eedfb70909484e5c4da70504dbcaa205bfef6216b7375ad6331a117f64855d68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eedfb70909484e5c4da70504dbcaa205bfef6216b7375ad6331a117f64855d68"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef05dad5de93685291443e22e2660fb36e916b4386d84f1340a7db0bf8003e1f"
    sha256 cellar: :any_skip_relocation, ventura:       "ef05dad5de93685291443e22e2660fb36e916b4386d84f1340a7db0bf8003e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b449adccd4326fd0fba4faf293798d7a3e3ab0f258616cbfc22fcc528b5496d"
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
