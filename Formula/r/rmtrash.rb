class Rmtrash < Formula
  desc "Move files and directories to the trash"
  homepage "https://github.com/TBXark/rmtrash"
  url "https://github.com/TBXark/rmtrash/archive/refs/tags/0.6.8.tar.gz"
  sha256 "9055a538b7e282aebd61f74241d5e2009455b1ae7e7029eba87bc41bbd684d4a"
  license "MIT"
  head "https://github.com/TBXark/rmtrash.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bfc33733f840b1f82a47a4da7c49ba55dfb8b1baed8c4df96d2a1d6fb7f217f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a30a53dd25ff977ad17267908d9d93d95f246e2d947aba78d181b5670a6ebcb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d28190fb40efa3936483dd2f550e15911e86d1d533278f2bcdbb9b85aa3741f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "485892442e561173e63328f83f8f1c24d0623a0584eadf13ac7d279518820678"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dab2f231c1d82859b8c2e43fd3e95a2e214c21020a67a58e91fd0805c10e52b"
    sha256 cellar: :any_skip_relocation, ventura:       "ea999346b7c78ea4678cc4ecf3712d25a3780a8686137d00faa34cc0b1565abb"
  end

  depends_on xcode: ["12.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rmtrash"
    man1.install "Manual/rmtrash.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rmtrash --version")
    system bin/"rmtrash", "--force", "non_existent_file"
  end
end
