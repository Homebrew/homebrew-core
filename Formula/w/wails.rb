class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://github.com/wailsapp/wails/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "3dbdf683ce67968c1319436950e6da1f27e6d64802d477105fc4d7a60be19860"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8ceeaba87cb335e3b3c8c555001bb253c327747a99f6a17d1ef1e0e8ce28142"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8ceeaba87cb335e3b3c8c555001bb253c327747a99f6a17d1ef1e0e8ce28142"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8ceeaba87cb335e3b3c8c555001bb253c327747a99f6a17d1ef1e0e8ce28142"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0dd839322e7011cb16696a82d861492ce9628c74f538ff6a37735126030f7f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60be7b63e0872b04ebec623f9db82f5ac391c66742cceeb1024d242287ff4d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aac802637550ce63eccab812d74fac2eb534a298357391dbe739c12887bd4da7"
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
