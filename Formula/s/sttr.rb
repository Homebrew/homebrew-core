class Sttr < Formula
  desc "CLI to perform various operations on string"
  homepage "https://github.com/abhimanyu003/sttr"
  url "https://github.com/abhimanyu003/sttr/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "64c4ddd6f84c99f197053e96c489dea48c0bd83a33dfdd69ab209653bc38b9c8"
  license "MIT"
  head "https://github.com/abhimanyu003/sttr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1fabf7a53aab3e69a2b42a474f524143bf15bf5f2a448fd6bb5aaceff8eff52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1fabf7a53aab3e69a2b42a474f524143bf15bf5f2a448fd6bb5aaceff8eff52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1fabf7a53aab3e69a2b42a474f524143bf15bf5f2a448fd6bb5aaceff8eff52"
    sha256 cellar: :any_skip_relocation, sonoma:        "eff47c0cfbea20e7735f4187b0034c20ae1e833f4f3fff832b9409a57412d7a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66489b5018db928761078bcfaf11c87ad3ea74e981943fbb53af7c06e684f296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3c432bf1cb5babeb063aafc6a8f468f02b9c801724369058e675105dc22a09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sttr version")

    assert_equal "foobar", shell_output("#{bin}/sttr reverse raboof")

    output = shell_output("#{bin}/sttr sha1 foobar")
    assert_equal "8843d7f92416211de9ebb963ff4ce28125932878", output

    assert_equal "good_test", shell_output("#{bin}/sttr snake 'good test'")
  end
end
