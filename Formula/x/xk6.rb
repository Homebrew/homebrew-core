class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "623e20fc5de3b5458e32be1d8b10d4e6960ad42b8d24a79465d451927fd24e43"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d74cf7ae14e338f58b0c83c07fd22277ae071975313f0b354cbb68dc8d402a94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d74cf7ae14e338f58b0c83c07fd22277ae071975313f0b354cbb68dc8d402a94"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d74cf7ae14e338f58b0c83c07fd22277ae071975313f0b354cbb68dc8d402a94"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3cf8afbd960cff0aff9059b1b48b9f0892b60d58e1e32b991954099c51ad948"
    sha256 cellar: :any_skip_relocation, ventura:       "a3cf8afbd960cff0aff9059b1b48b9f0892b60d58e1e32b991954099c51ad948"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fcecf5eb28ec11ad23b163159becd1ceabb80c2484686f0a42ea761de608ee4"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/xk6"
  end

  test do
    str_build = shell_output("#{bin}/xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end
