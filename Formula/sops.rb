class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.7.2.tar.gz"
  sha256 "905d0d85e6f3a36eb0586bae5c1bf501445841303e597136f69a33040f5123b2"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b624e63dd53118056a25e59ca1e757e03adbf527d95e1c0eefe4487187c9706"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45d2aa787e93eb803eb6ff266a92c589ed76870afcf44176e768b573d9e16ee7"
    sha256 cellar: :any_skip_relocation, monterey:       "6eebc96fa87ee730b79195166bdc06f27896c48541866f3c64105e32aa177c40"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8e5994725fd84140926d5420fd86f4e5a3d26994a7a646196008b00dbd14944"
    sha256 cellar: :any_skip_relocation, catalina:       "72e11a7d6e537e2c3cfe73c128c4fb63bfaf170fb25f76d1127ef5d9a3c71fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262fbf530682ad43100ff2e502cb869dfb8b1071e6396fc697ba843db3cff0f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sops", "go.mozilla.org/sops/v3/cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
