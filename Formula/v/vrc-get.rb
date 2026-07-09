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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bb9ca628607023ff346372dda18afa8edab223f5d136a477a0b99e143044f58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e14d015ebf6bbe795ffe04efefe6fd9de66c74bcd76232b8878d6ce49a4b59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c9b9380b0fa8f3be0f2bab8fb09567b1b55164199d528a3024de3eab62413a"
    sha256 cellar: :any_skip_relocation, sonoma:        "6432ad3d92e067a2fc07e60d8e06b8f9be7be8162cf92f0a93d68aaeac9e2d54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f67fd59ed2c881073a61792a947674c006d3baf16b26de12f35486a7cc49e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab15413c486191dcab9de4a69630c60dc5095b7550151012639debb2fb790dcc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "vrc-get")
    generate_completions_from_executable(bin/"vrc-get", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath/"data-home"
    system bin/"vrc-get", "update"
    assert_path_exists testpath/"data-home/VRChatCreatorCompanion/Repos/vrc-official.json"
  end
end
