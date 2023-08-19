class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.20.10.tar.gz"
  sha256 "99b540ce232a1f965a214470df9e40fe805c644854fe3b237dcc8a0669e252ea"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "059b34aff25f0d0882ffc4e4a81912f0f289c3aa752124ca980e4d6e6a865f78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80b30a7b9f66db8b570a576c6e3bd3630bc01729b43e1d565c391eaef759ccf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "856e14789c04604ef021c4a5df789825b600a9f9d4abd16f7626c28a0bb72d64"
    sha256 cellar: :any_skip_relocation, ventura:        "831ecd558dfb13225f3c0d837caa0f2f7916bd671badc24b20b11589cc28ffe2"
    sha256 cellar: :any_skip_relocation, monterey:       "3966525f60a8f1eb431932533ed79dbb0bcf27e250e2680d5d85d79f7afd1624"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe4f719e3b9cabe2c0342ee49e1e7bd45f157c22216ea599df100ef869ab0bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adfdc71128ef3d9e26036602d54c2be8fbb71f3d784c8440f5958bdcb7719a26"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin/"steampipe service status 2>&1", 255)
      assert_match "Error: could not create installation directory", output
    else # Linux
      output = shell_output(bin/"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
