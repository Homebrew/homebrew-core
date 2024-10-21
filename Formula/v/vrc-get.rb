class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/vrc-get/vrc-get"
  url "https://github.com/vrc-get/vrc-get/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "9dbbaa1addf018e139d87678f8669d0b025502be38afd46f8abd736a3784813c"
  license "MIT"
  head "https://github.com/vrc-get/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fe3d7f8abc6d60dcbdddb9c0cce37c1a0071c979e1dceeaefc09b4b37837d0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba8402442b4b96839d778fa7fbbde67351fec04d35a6cbee551eb86ca635add8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddf20ad40958f02b1a3f52be12f2cedafa8939932f12022c491330bedcec38be"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3cc1776e18988d7fe339f25eb6d1a408734e1d4b5f67244efb7669ac7f651f4"
    sha256 cellar: :any_skip_relocation, ventura:       "132efaf1418a43cfcffb2e8159b4b27984843bac08f333556dd358abaf63874f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc6bf0b5fbbcd6643f5570af91514a1b4cad94d240078c5f2814c7d1765614b"
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
