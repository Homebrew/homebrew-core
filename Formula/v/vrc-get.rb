class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/anatawa12/vrc-get"
  url "https://github.com/anatawa12/vrc-get/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "6698ba5e50367b6e966699210fdeb6af543c6e82d08eb9ba9040837e745dc404"
  license "MIT"
  head "https://github.com/anatawa12/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4edcb4ba28ef382591813d82566272039dd15151454d99a819a7317da44185e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e92f33992df9ce46002df03ab425ec9341243375b3fd9bfd9950fc8c749995f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2643dac9c19f9bc0af267b3314fed78397749195a9edf2122099ae4cb257d9f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "08823b5ca40f1bfc4a87d37e862d69892bc0975d0370fbf645f56ee5711edae3"
    sha256 cellar: :any_skip_relocation, ventura:        "02f26021f31a2e781129899b2fb59caf629cd51b6fc1a26ff0e7ca45da3866d9"
    sha256 cellar: :any_skip_relocation, monterey:       "77f5b1e093a3a5d9fdf46937b05d78397c87318682f1d49ff2c9759b29cfd515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d98048b64752fe39e724e22c3bf2b0cec8e939c594f0efd7d59ae7aa9ac16a"
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
