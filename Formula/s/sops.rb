class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.8.0.tar.gz"
  sha256 "14fa25f2d6177c5444934612398426a8de3caf59348eae8cc228291cf750288a"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5800bcb0f7d2a08051fd6d57e08b65fca6298269f03908d296af5e3cfc141644"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c294245f353b7ba5c9beaddda1bc04a5abb7a909ea8907aeb28a91280d2a08c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10586978a703171675cf8468994e87694c3b00abb6823746ab57323006b499ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e837c4c69cbc7cff6f8e1d1920dc70c53868decf3f7b4306e32238888d22a5b7"
    sha256 cellar: :any_skip_relocation, sonoma:         "58826ba1cde5183cf10c4c124435d687a2265e1d199d4cc51f5aa8b67d3fff28"
    sha256 cellar: :any_skip_relocation, ventura:        "8f3c1d7d27a2f22a361d10277b7f70b8b290ae33caad242eb78496ee5e9dae20"
    sha256 cellar: :any_skip_relocation, monterey:       "ec86acaef5db4c6b357ce76d71cd2e5eb264d07dd42f33265656affbe34c2ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "de31c1b00e5612ceee165fd43229b17700b6d48ab12dfa7f3450f3865066c06d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90f27705e0039656996f71d4ea9f67f253ebf2550ac384ff4088120b8918b7d0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/getsops/sops/v3/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/sops"
    pkgshare.install "example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sops --version")

    assert_match "Recovery failed because no master key was able to decrypt the file.",
      shell_output("#{bin}/sops #{pkgshare}/example.yaml 2>&1", 128)
  end
end
