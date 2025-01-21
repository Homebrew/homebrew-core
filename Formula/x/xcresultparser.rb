class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/1.8.4.tar.gz"
  sha256 "7f9b14e9705fef17b1d9c7050e209f7f84ab3f35ed3d9359a3c0bf1f14f90f89"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d86dff979f71a9c42f81741e60fee949ce3c38724ced11cfcbba306c9240c208"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a3668eb141370aa45dbf6af71c19b0399a2cf368bb0eaa809202f72e4a77821"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78e656ea44e213fd9033d2b5aa95641c95031cd3d3247ee8efbf2c982a2638be"
    sha256 cellar: :any_skip_relocation, sonoma:        "df387945f44bdffc2a9e98edbf7e866eb9da1f64d55852bbb2dfff2ac2fa806b"
    sha256 cellar: :any_skip_relocation, ventura:       "4d73e0dee342306f537afd25c81b5fcd5e491020ef0413e7327c795ea16267e7"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcresultparser"
    pkgshare.install "Tests/XcresultparserTests/TestAssets/test.xcresult"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcresultparser -v")

    cp_r pkgshare/"test.xcresult", testpath
    assert_match "Number of failed tests = 1",
      shell_output("#{bin}/xcresultparser #{testpath}/test.xcresult")
  end
end
