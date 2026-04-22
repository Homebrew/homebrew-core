class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "bfc663dd01f762c5524006d945616c5ce361055fa649ebc3b1ae2a16247d8fee"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "123d4a761d220965354412a7296430d325381120b351627255cd85fc258164ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "123d4a761d220965354412a7296430d325381120b351627255cd85fc258164ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "123d4a761d220965354412a7296430d325381120b351627255cd85fc258164ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "2535ddf6a7c2a8740c717b70a54443ade662bd435371b3c6eaef4ccc5dd9ebaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cd2739ffc1bf176c016b3a6a8b0af7274d554e00a0a1b1da3597bf2cd5048dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8779c7b2548e06be05de74676f9467160f722c2836587d71e548c0f08ad8bab4"
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
