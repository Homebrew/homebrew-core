class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.9.5.tar.gz"
  sha256 "2089c9660f2200cdb56bb6c0fbd039bd411dbefd3d64a42bf44c99540fe4e8c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "309df94b09a32952fda11a503d3a109a21904b6e57d503dcfbf4f8a9bdb25766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c7ffd4f60bc08f569d67cac24ee82a7909fc2e8cefdb6ab50c8fe5da7d68cf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19fc667d1b658e589dd668a4c01fa23d741552487657f64f450bba1dfbb0b5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "501adabfa02cd99fb515267548bfb028a43a3544deb17b5172dce4bf89b92a32"
    sha256 cellar: :any_skip_relocation, ventura:       "a5e83673066d14fcdf2a0ba57508eb5bd3ebd9f6b85f5b06d9f08811d0988e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccc721c53de10e9ac82002ebd26376743a6352a326a8590b754487b4bc9c66fb"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
