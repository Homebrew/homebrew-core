class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://github.com/render-oss/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "0a9da315b0d5563460161228c0b882ae599936f22774f517c61369029877d5ab"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf13994b68adf5449485fc63e5c4a0a63ca431c1179e3d929692e21a01c441a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf13994b68adf5449485fc63e5c4a0a63ca431c1179e3d929692e21a01c441a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf13994b68adf5449485fc63e5c4a0a63ca431c1179e3d929692e21a01c441a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "23ce39c0bb94ad61e8187ab0afc3e1cf28ec4514bf836d5256f9351d881ddf9d"
    sha256 cellar: :any_skip_relocation, ventura:       "23ce39c0bb94ad61e8187ab0afc3e1cf28ec4514bf836d5256f9351d881ddf9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02fb948e8af3bfa41c8ae09cbca819ab18bd8134b3fe503f14d17e541df6d025"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/renderinc/cli/pkg/cfg.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    error_msg = "Error: run `render login` to authenticate"
    assert_match error_msg, shell_output("#{bin}/render services -o json 2>&1", 1)
  end
end
