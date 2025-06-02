class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https://k6.io"
  url "https://github.com/grafana/xk6/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "db0af1b8969e307a531b362039fbfb030a568de17763a6825195d958c73352bb"
  license "Apache-2.0"
  head "https://github.com/grafana/xk6.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c30883a97b9390078624953d716ac9a28381bc4750ac8439a0b4056b2b929bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c30883a97b9390078624953d716ac9a28381bc4750ac8439a0b4056b2b929bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c30883a97b9390078624953d716ac9a28381bc4750ac8439a0b4056b2b929bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1fb3fa00507d7cf6204eee0e6bd075687526c6a7b7dd195c7b00cbb4893a47"
    sha256 cellar: :any_skip_relocation, ventura:       "6f1fb3fa00507d7cf6204eee0e6bd075687526c6a7b7dd195c7b00cbb4893a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7dc28e2fb92b4cfdc65de33fb2a5eb4d495269a75ec4bfc997054c47642ed4c"
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
