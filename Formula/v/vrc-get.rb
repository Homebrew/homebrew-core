class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/vrc-get/vrc-get"
  url "https://github.com/vrc-get/vrc-get/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "a8d35448a01b70df0753dd264c096a32b21dc2bd2ef9b5a54423c4309c7aa3db"
  license "MIT"
  head "https://github.com/vrc-get/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de850d693542af7f6e08660d844b13e76331feed2e0ac47367bebbf9816bc4b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12597ac2dd9b97563c431a6c0220ad2daa8bd519d18467ebf0955d0ff0682670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e96d29ec329670fd8fb921193e07ef71e5699358df6b60ee65a14fc068927526"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3660f27b64f9e969466fe49bfa55f631dd67ce978bccbac2f9826033637de250"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c4202ebc728de42372a7db3a926572b7de9de197a1deeb35f207be9f5d131b7"
    sha256 cellar: :any_skip_relocation, ventura:       "d108f92673c5e0502b59e7682ddaa208886bad7a8162fc2172315759ba20aae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecec52be3888898c5755c085e97cdb6aab7c36ea33ccf5a8adf81735de95bc93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf026916c83f75b0ede1071e1cd8c1eb87a74d131456a6bd417d8e31edc7580"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "vrc-get")
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath/"data-home"
    system bin/"vrc-get", "update"
    assert_path_exists testpath/"data-home/VRChatCreatorCompanion/Repos/vrc-official.json"
  end
end
