class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "c7422e4fe8f8f82fb90b86fdb9eeeb1e6b9dba27d5eb63347991bdefbc7af159"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0015f3b0862f2bf36e5193e4302fe2ff38ee9bffb290efe3428f6cab30391075"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b034cf34ea209c628f37487bc73c5fa31ff7ef7c877fd80f61186e32d861eea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bee704c2c822953f1d014d086f4a7bc0889275296f1f67fea1115be59b0ae19"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f6f0b51005182480d4a8c716cea0b2664a6aa2bd80ec12c638ed4e1b0691e1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb556cb519b96e91784612bc16c536987de1aa3cb39c8a25a8f2cca7ef4a4685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6d5eef56c9ad5254604bdf349b5494704b55298c456db64b50e19f78fabe62"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
