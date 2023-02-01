class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "92cc09febd2eebe90825b72ada0426510b6b372d61e4bef7a5df3e61eed59aeb"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "593433191d6be62fa169eef1792c1f880e1ccc2caace140d397c6adb9c390d4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cc84bc11876259540fc775f9c0772293ae60e867d00278f631ab98cbbf76080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ee30ab7bb2d37d7d4e4962c9b53d96cbe00341dceebf2bd04e3ac0494c28823"
    sha256 cellar: :any_skip_relocation, ventura:        "19cf7017e019a6fe9a361a4fdc76fca9f502c4d4a428eb8916ad637e0cb982ef"
    sha256 cellar: :any_skip_relocation, monterey:       "ef2540b5e2f61b78e6fbd876437a4f3d1a7c65a74f09cde1d996a6cb26e91793"
    sha256 cellar: :any_skip_relocation, big_sur:        "15ebb5db0bfb49a672e0a886754df66cbb8a911e27db85a50f66d2a6e6219711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7826a5bbd480e5a24bfd743dd3a5037c9325524f284891c8b416ae169aaa7bbd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
