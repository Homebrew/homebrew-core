class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "dc595807a0ab875111dafd55be9f3de116cbea652216f9d0082d03dddb3d83be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75762beb18143e2ea4b4f9ff6518f62a67cf5f909d053ff6b9120bedbfbe13a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75762beb18143e2ea4b4f9ff6518f62a67cf5f909d053ff6b9120bedbfbe13a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75762beb18143e2ea4b4f9ff6518f62a67cf5f909d053ff6b9120bedbfbe13a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a131397f7f865c776486024e4668308ff4a63922d7eee805c1c2c307585c235f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1001846eec11d144b88ee69a1c3ee92cbd310b927cfd3155fb238e2045141864"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b618682972c1079e2d48c2edfff5af4127d50ea45a7768fd5c483d29bddb1c94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
