class Wait4x < Formula
  desc "Wait for a port or a service to enter the requested state"
  homepage "https://wait4x.dev"
  url "https://github.com/wait4x/wait4x/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "5b8e4ceaefd3902cda157aebd01dae76e29d7c93893fba7eacf7eb1a0ef17c27"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "017b09c350d278a5916f10ed69d2120c43835ce0a7670e37c22c94ad4a4faeeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58fd9669cd088fcf3d427ebdde2465d6667e49de0de40387fca77ba3d24e6671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3fc7eb786fc3559418a298daaf03037dd0beee74c5bcf72873f54abe933bf74"
    sha256 cellar: :any_skip_relocation, sonoma:        "743feaa258230868fe79d09e1805c007191ed582976313e274fed1dc65ab24ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d012089d4f4b6615ec8cc185bff353f4a5ac192d92d4b4563453dcd5ebf39fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb771083743f1f09be76c98a42da409d1fd11e43055d580b6f5de70ebd42515c"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "dist/wait4x"
    generate_completions_from_executable(bin/"wait4x", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wait4x", "exec", "true"
  end
end
