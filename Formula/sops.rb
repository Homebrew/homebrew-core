class Sops < Formula
  desc "Editor of encrypted files"
  homepage "https://github.com/mozilla/sops"
  url "https://github.com/mozilla/sops/archive/v3.6.0.tar.gz"
  sha256 "fee1c27f14f9f45b5955627e301aafcc38973c9458b25f99ef241bdd0a3b082c"
  license "MPL-2.0"
  head "https://github.com/mozilla/sops.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d12db4156e6c2eef594c07d15d76f92ee22847334206f9d55be31a6ddbfc7e23" => :catalina
    sha256 "2a7127a49b5bb27ea9ae2ca7da51d4473d6cc182f933e1aa31732ee98b2bc7e3" => :mojave
    sha256 "3f93dfcca630ce24ddf54008c220c76642784e29b05dd4ff7396ace3f489dac3" => :high_sierra
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
