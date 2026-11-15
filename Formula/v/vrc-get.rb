class VrcGet < Formula
  desc "Open Source alternative of Command-line client of VRChat Package Manager"
  homepage "https://github.com/vrc-get/vrc-get"
  url "https://github.com/vrc-get/vrc-get/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "8c5704c7ce48ddb6e3485528edf1b2e9ddabc6872112ef0a07a781867ab2fb9e"
  license "MIT"
  head "https://github.com/vrc-get/vrc-get.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9999f458a499216cb7a488b04293fc7e815dfe94e6149e3e34854ecf283c3135"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abdbc9207bae326637da383349459c44028a8ea2376190050d497c92f0ae8a68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d885146c462784b52195129c420f55b0e53e6400388257b9b2de4350729a5a5"
    sha256 cellar: :any,                 arm64_linux:       "eee6eedc88e7b5b8f1c4eae6ae4c5a650a5fa8c14caaa9c67f2abe8ea94ac738"
    sha256 cellar: :any,                 x86_64_linux:      "9bbb59e6d9f211d8d4a0ac1c0c6c2f1c740c15724a67de68fd4bcb28f9af26cd"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
