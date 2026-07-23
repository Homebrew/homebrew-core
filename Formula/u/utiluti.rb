class Utiluti < Formula
  desc "macOS command-line tool to work with default apps"
  homepage "https://github.com/scriptingosx/utiluti"
  url "https://github.com/scriptingosx/utiluti/archive/refs/tags/v1.5.tar.gz"
  sha256 "84acd1d0e63d85fcb4663639f040ddc5763a2ac317a6e1613de2d2c245faabc7"
  license "Apache-2.0"
  head "https://github.com/scriptingosx/utiluti.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "442eeea49c01e4615962ef30340a5bcc949906223c39e157b21b5160d5573c82"
    sha256 cellar: :any,                 arm64_sequoia: "2b4bbc74f26387db21f628d23ebb880a0b5a794b18a15b886a63d8c5aff502f3"
    sha256 cellar: :any,                 arm64_sonoma:  "5cad6055463553d8f64c68a1f78500835dded2a21395b5830be7c2c156ca5e0b"
    sha256 cellar: :any,                 sonoma:        "6b3f20399145a7efafcd4756fc4efa4848afbb1c5aed2ff690715f8974d43a32"
  end

  depends_on :macos
  uses_from_macos "swift" => :build, since: :tahoe # Swift 6.2

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    system "swift", "package", "--disable-sandbox", "plugin", "generate-manual"
    bin.install ".build/release/utiluti"
    man1.install ".build/plugins/GenerateManual/outputs/utiluti/utiluti.1"
    generate_completions_from_executable bin/"utiluti", "--generate-completion-script"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/utiluti --version")
    assert_match "public.plain-text", shell_output("#{bin}/utiluti get-uti txt")
  end
end
