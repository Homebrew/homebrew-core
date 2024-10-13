class Xcodes < Formula
  desc "Best command-line tool to install and switch between multiple versions of Xcode"
  homepage "https://github.com/XcodesOrg/xcodes"
  url "https://github.com/XcodesOrg/xcodes/archive/refs/tags/1.5.0.tar.gz"
  sha256 "f55fe5c35fe7b4d76e5a0a90991b43fbac8fd4b0801cafaa60f958c5f3eaca92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0884a0ddc627e9d30425d19f57be402aaed2d3c824b2ffc607ae7d7870ef8275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5ac938d7aa777318b6f2c1df21990fb41c823431b1ed64a2b9a1071b8a42bcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e089ed9e1698abf3958ac72d807b02a244f61975d21f0dc581cd25516a19a755"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e13f8b8e2a2e858c2bf7376268ecf9db5d0ca027cde2bd2e2e6e81b0ad057e"
    sha256 cellar: :any_skip_relocation, sonoma:         "b22180902cf0edfd08d6e20ff991ba024dcf5e0c07e4f4d4c5a31bfeccfd845c"
    sha256 cellar: :any_skip_relocation, ventura:        "017cd7a0ea7b8504cf126c68357b37c6a6a5ba532fe274a9fb2c4be5617a3d6c"
    sha256 cellar: :any_skip_relocation, monterey:       "1aa5c7469e3b9eaf3a968b350fba1d66b1b9fd550a9265587b41d27af80823cf"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcodes"
  end

  test do
    assert_match "1.0", shell_output("#{bin}/xcodes list")
  end
end
