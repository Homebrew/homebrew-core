class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/vrc-get/vrc-get"
  url "https://github.com/vrc-get/vrc-get/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "669af4b5a546b0991607ebee91f352cea6c5ae430cc7cda7736adafa0cdcb3d8"
  license "MIT"
  head "https://github.com/vrc-get/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43b765373df7aaf2f0262d8614c0ffa1feb30a678ea6273f322c32459f4cb79c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c12cd0836fedb083500540ecfa9c71b5977cc189cb8585ab182dcb173212afc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7315dc588cffe1da2d1290b132a95c24a99b4e0b89e5b9a07e1f549bc53998fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ee10f04f7bd12af38057340ad05ea6822c5c8f722926ba5ca0fd8e7b4dd32bc"
    sha256 cellar: :any,                 arm64_linux:   "7549a5500553999eef195a0cfc626ca013de515502d527a488dfd248dc312e6a"
    sha256 cellar: :any,                 x86_64_linux:  "0d789cdb004317cb64c531cfecc014ae3cb8273091f7060da565b6c9795bc98f"
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
