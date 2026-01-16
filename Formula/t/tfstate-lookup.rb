class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "db29592c4c3c950e8902cb77bd05ceb47c275196c1b261842f3901e7a4ce8b3c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f398533d213ceb02e8931594dbfa567478f93b97399f878171560234bf94d58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f398533d213ceb02e8931594dbfa567478f93b97399f878171560234bf94d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f398533d213ceb02e8931594dbfa567478f93b97399f878171560234bf94d58"
    sha256 cellar: :any_skip_relocation, sonoma:        "d612cfad01febbd1dfae6ebefb89013bf759c56121ede3457a2c34d351ca6eb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9152b9d2c33ee75fab8024b55686801c8d9467a8fc82d1960c39c676276eb4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "822a06dc519cf847e75b4cc240aa763e1cb2eebd1c3e481268996ac2cc87335d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tfstate-lookup"
  end

  test do
    (testpath/"terraform.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "1.7.2",
        "resources": []
      }
    EOS

    output = shell_output("#{bin}/tfstate-lookup -dump")
    assert_match "{}", output
  end
end
