class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/anatawa12/vrc-get"
  url "https://github.com/anatawa12/vrc-get/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "8ad73183ce957abc63006c97efa63314c34e1f0f6f2ec0a55a48f5a8147c199f"
  license "MIT"
  head "https://github.com/anatawa12/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9995159222e42c59776ac5266bdae9dfa090789974c79ae02e18f37693c4956a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6996622a570ba9d9ab3dcb432682f3c7a4a6d8cb574fa60d9f31cb5dce775b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6dc6347526f1d62066a1b481d91d833c3b8030cb1f13f1f300e20888cda0ef9"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c0694a71e1c9cb8a88216f0ba1d604fd142d62e8a69da80fc4d7f53dcedf953"
    sha256 cellar: :any_skip_relocation, ventura:        "384e0f46ad5f4e3eeb1b79566eb4c24f44376f3786f8971f092c0a98ce2c2314"
    sha256 cellar: :any_skip_relocation, monterey:       "e0b2a14fe2d2f5f0b3539682eb2ef7078cd473c5c49478abda6a5fef77e9e5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18c849e7b87d7b66693e34fd0a8a2199ba37c2eac76fc26119d3780a2f1bb5f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "vrc-get")
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath/"data-home"
    system bin/"vrc-get", "update"
    assert_predicate testpath/"data-home/VRChatCreatorCompanion/Repos/vrc-official.json", :exist?
  end
end
