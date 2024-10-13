class Zzz < Formula
  desc "Command-line tool to put Macs to sleep"
  homepage "https://github.com/Orc/Zzz"
  url "https://github.com/Orc/Zzz/archive/refs/tags/v1.tar.gz"
  sha256 "8c8958b65a74ab1081ce1a950af6d360166828bdb383d71cc8fe37ddb1702576"
  license :public_domain
  head "https://github.com/Orc/Zzz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fd0ee248946ce362be9296be1706999d0e32f120f86e07923d5f98f58ddd014b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87aded93dd5a70ab018880e46586b6a7c0929414def405edb1db0e1e6b7a5936"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da5ac10ecb8c990e69702b8c671a701d662ab63755a25b2fd0a90e84790f007"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a1135d50a709f3c6a64316e5a92a6f269bdb865d21fa26e279c38344afde541"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e08914c722e58a5f5a43c70b395a198faf42e08bc31476fcf226ee77bd42195f"
    sha256 cellar: :any_skip_relocation, sonoma:         "75d43876070b1f6160b4cb6a07f70599a4aa50556fc542c2523397d30ba747bc"
    sha256 cellar: :any_skip_relocation, ventura:        "0466ce782b6410ac3fd3df809c516c53763a9e4a90d1ed81f48118090dd497d9"
    sha256 cellar: :any_skip_relocation, monterey:       "086a43f796e1d9630aa6980fcca37971031e37234f065295d55f4de1f72c8c35"
    sha256 cellar: :any_skip_relocation, big_sur:        "3609040838445e383713a328d0838510d77c3d222f8ecd6892e0e99455668ab1"
    sha256 cellar: :any_skip_relocation, catalina:       "10b1c9f9822b1cbadaa5774d0ee28c1016fa4477cbe3442475ad9113f0b98dd4"
    sha256 cellar: :any_skip_relocation, mojave:         "46716ef74ec052c11d497b5192b9829d1341ebbce783c04be344a85bb9dd5a96"
  end

  depends_on :macos

  # build patch for main function signature, upstream pr ref, https://github.com/Orc/Zzz/pull/6
  patch do
    url "https://github.com/Orc/Zzz/commit/efb6f6314722de65e709df6dc5f94284cf12abaf.patch?full_index=1"
    sha256 "6e92a6d87c7ddeff5308318b80f4287434cf793a4cf2b1761193b5aff2ea5867"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  # No test is possible: this has no --help or --version, it just
  # sleeps the Mac instantly.
  test do
    assert_predicate bin/"Zzz", :exist?
  end
end
