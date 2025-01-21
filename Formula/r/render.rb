class Render < Formula
  desc "Command-line interface for Render"
  homepage "https://github.com/render-oss/cli"
  url "https://github.com/render-oss/cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "62d2b561c501646f89045a26d6a9a7d9444457bc725ac0cb1ca9ec204cf334c1"
  license "Apache-2.0"
  head "https://github.com/render-oss/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba1a213243d78fbc83f050e98c028a4949c14755fa70549046d1c8686ab75ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba1a213243d78fbc83f050e98c028a4949c14755fa70549046d1c8686ab75ead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba1a213243d78fbc83f050e98c028a4949c14755fa70549046d1c8686ab75ead"
    sha256 cellar: :any_skip_relocation, sonoma:        "597918a4eac08712ab8003048ff1e84408e9b484dff00fe691504849a18215fa"
    sha256 cellar: :any_skip_relocation, ventura:       "597918a4eac08712ab8003048ff1e84408e9b484dff00fe691504849a18215fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc3915c26e55c642ffefef301e2c31f238666955a896dbab5efe56f66efacda"
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
