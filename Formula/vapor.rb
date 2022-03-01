class Vapor < Formula
  desc "Command-line tool for Vapor (Server-side Swift web framework)"
  homepage "https://vapor.codes"
  url "https://github.com/vapor/toolbox/archive/18.3.5.tar.gz"
  sha256 "a138cf744b6a0230e02761f2f953085254561f7161b13aa61c7852ada4306b99"
  license "MIT"
  head "https://github.com/vapor/toolbox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "608426e628553d67209741eeaaffedfb71f9edadaf9e564e194d1270123ae932"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1346e84a707246eb6ab26772a0996d269c52d36953f19dcc6e79af92a9df01f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d91642fe4f913851bf589f5413f3b4387d35798dd5c10be564b8a8d63904f24"
    sha256 cellar: :any_skip_relocation, big_sur:        "8822a3f3b557d6fbaa01feb384fc8729f7dbdbbb2afe4b7c46fee6ea348d008c"
    sha256 cellar: :any_skip_relocation, catalina:       "c1bbda43b23e9679a0635261f1379a3a2411146f6b0931953111ac545f00c4da"
  end

  depends_on xcode: "11.4"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc", \
      "-cross-module-optimization", "--enable-test-discovery"
    mv ".build/release/vapor", "vapor"
    bin.install "vapor"
  end

  test do
    system "vapor", "new", "hello-world", "-n"
    assert_predicate testpath/"hello-world/Package.swift", :exist?
  end
end
