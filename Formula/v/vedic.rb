class Vedic < Formula
  desc "Simple Sanskrit programming language"
  homepage "https://vedic-lang.github.io/"
  url "https://github.com/vedic-lang/vedic/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "9bfb68dfa8a79c02d52905eb1403267209dae80ad05287b7f3706f14071c4800"
  license "MIT"
  head "https://github.com/vedic-lang/vedic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "56502244e08e30a3a86559996431cd27db1959096e6b465c56c793c2495ebd23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4afe71c7c4dae3f9edfd94229be33eab94b9349f1a50c787b2e98ba07a34861f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9bdcd049f25d6408a40c2693a39e098ae74512801535b6fa6539566375f679f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fe45503d405ec81208fa88cf42b7dbe9fa003316c3783dd4d53ff19f48e89ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b737a9a7256fc30550659cebf7214dadbeb155d49eed775b84a91dff83c7c5cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "a852103a96ff00273820b27230d0f482cf1690978c2f6587b1f7f778a343c4f4"
    sha256 cellar: :any_skip_relocation, ventura:        "c012da02f916791259476071c8fc1bdf92e3273033411b90154b43672e39bbac"
    sha256 cellar: :any_skip_relocation, monterey:       "7a53d21f56acac6b0322b0da98880f29efe8f24badfa62bb850d6ff52a4da378"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1ea67bafadca41308429cc2ffa531885f65a4ce2eb6dc373148f87a8c00356e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2334b13281923d5c4f0964b6ce0ea51e8770866304de94b76e6de92d200566e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # hello world in vedic
    (testpath/"hello.ved").write <<~EOS
      वद("नमस्ते विश्व!");
    EOS
    assert_match "नमस्ते विश्व!", shell_output("#{bin}/vedic hello.ved")

    assert_match version.to_s, shell_output("#{bin}/vedic --version")
  end
end
