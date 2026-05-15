class Tpix < Formula
  desc "Simple terminal image viewer using the Kitty graphics protocol"
  homepage "https://github.com/jesvedberg/tpix"
  url "https://github.com/jesvedberg/tpix/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "2d9fb663a9aea3137d2d56fd470e2862ee752beac5aef2988755d2ad06808dd9"
  license "MIT"
  head "https://github.com/jesvedberg/tpix.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d87b224ced00e835b796c34ed8a01440b0874174f6c3bc872e77f01c31d848f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a652e7455804c8862979ae45580498901bfcf07d08fa63b9899183efd50b9ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23b065fcf26d392475c389f55d51e4291b9b31875c9dd008c82e903868c4d633"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed51a1847548c67c760ed0afec619a32ff7c51756cf5fc10717def6dd56e90fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ea9eff7220055aa15a36c5c9848b235a447f6e4374b9c91febe6f45f358549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b797cc1be957d9b85f439bf5ce1e5f26a689f34025513019378f117006cfdfec"
  end

  depends_on "nim" => :build

  def install
    system "nimble", "build", "-y", "-d:release", "--verbose"

    bin.install "tpix"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tpix --version")
    assert_match "\x1b", pipe_output(bin/"tpix", test_fixtures("test.png").read)
    pdf_output = pipe_output(bin/"tpix", test_fixtures("test.pdf").read)
    assert_match "Error: Unsupported image file format", pdf_output
  end
end
