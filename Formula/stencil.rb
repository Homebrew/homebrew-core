class Stencil < Formula
  desc "Configurable static site generator"
  homepage "https://getoutreach.github.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "bf8f342963362d580cf75afb8608b1bffe93ad0b320df7d9b21ef365d8332c6e"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version}"),
      "./cmd/stencil"
  end

  test do
    system "#{bin}/stencil", "--help"
  end
end
