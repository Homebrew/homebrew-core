class Wego < Formula
  desc "Weather app for the terminal"
  homepage "https://github.com/schachmat/wego"
  url "https://github.com/schachmat/wego/archive/refs/tags/2.4.tar.gz"
  sha256 "5ae1c76a322ff2e295034a801755c42b0cb6bdef5ab205af42cf95dbf7c570f4"
  license "ISC"
  head "https://github.com/schachmat/wego.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "591831e4debaf931b8a40abaa611fc0b694e269a008627a1e672b5c81e31a9c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "591831e4debaf931b8a40abaa611fc0b694e269a008627a1e672b5c81e31a9c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "591831e4debaf931b8a40abaa611fc0b694e269a008627a1e672b5c81e31a9c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "688840f5a042c1c4aae5329e9fefd5c11f294bb2eae10fb90696e520113a92ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae7cca0c98758eac802ac7a5d0123df9b5c9fc3df187057cb6d96441aa83b003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c8c74038135b51fd1058c1c289d9d80e9cf75d0e02d6f6858e046009e4197e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["WEGORC"] = testpath/".wegorc"
    assert_match(/No .*API key specified./, shell_output("#{bin}/wego 2>&1", 1))
  end
end
