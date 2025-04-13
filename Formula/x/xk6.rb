class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b62580366d2c5f93e7299ec0cea887f62d024f762d0661f1310680f559370ed0"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90d7ce8056e21188b9fcf2f968600109e2458123ac32ddd6dcd6a44aa43be7d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90d7ce8056e21188b9fcf2f968600109e2458123ac32ddd6dcd6a44aa43be7d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90d7ce8056e21188b9fcf2f968600109e2458123ac32ddd6dcd6a44aa43be7d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "179de26ef0f3728950019437acd7723d809ef3a59ea3cb7a67093fe82a7c5597"
    sha256 cellar: :any_skip_relocation, ventura:       "179de26ef0f3728950019437acd7723d809ef3a59ea3cb7a67093fe82a7c5597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75fe3a8b53f10bc277ce3b76af2907e2f4858e530bfdc3c10a507d33d29987c0"
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
