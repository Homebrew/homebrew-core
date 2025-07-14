class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://render.com/docs/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "337e0c786ae796626ffe51699d67e2a875abb65e61f55489a19e2e120bd2568e"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8ef690c5923b9ecbd29e6162dd9f7964f7f20dfaf33e04f51772f78940952af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8ef690c5923b9ecbd29e6162dd9f7964f7f20dfaf33e04f51772f78940952af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8ef690c5923b9ecbd29e6162dd9f7964f7f20dfaf33e04f51772f78940952af"
    sha256 cellar: :any_skip_relocation, sonoma:        "092765d8863cd87864afc40dda4994e9548428babf8a6093a2ed382c01d33458"
    sha256 cellar: :any_skip_relocation, ventura:       "092765d8863cd87864afc40dda4994e9548428babf8a6093a2ed382c01d33458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e12127c0094c0a343e5ae12254a06ba7211c2a3563e248d8c5352dcdf264a4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/render-oss/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}/render services -o json 2>&1", 1)
  end
end
