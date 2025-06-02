class Srgn < Formula
  desc "Code surgeon for precise text and code transplantation"
  homepage "https://github.com/alexpovel/srgn"
  url "https://github.com/alexpovel/srgn/archive/refs/tags/srgn-v0.13.7.tar.gz"
  sha256 "324e31e732646bcc0344ce0ecc684f0d852ee1ce370dae162a9b9544432c133a"
  license "MIT"
  head "https://github.com/alexpovel/srgn.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "757bce0062da09576f735d0355461050cf686deff60af030bf9e5e45f19dcbee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ffc0e826cdef2bb8c93ce0a2ababf9eccc7444861e17ff6ba7dbf549505c3c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bbb71cd4e333a322e98b206c2d82846b05f26e1fdefda5bfb24b7c299d8a67f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "af3b185c308534c5ecabfc6affd67a622bf95bdc9f8eb805a2420a0c010c9039"
    sha256 cellar: :any_skip_relocation, ventura:       "478896e4b048e539911f1b8c1439e7d2b86cff906fc59a834e86cb7f6f744668"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "574a9af2b871bddf3e5c1ff5f3a1ba10158a79ae936d24065912589c910c438c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "415af58ce82dbbc7f728656bb41fbd74b7b9d78eb9d7bf68ef30843b0f789489"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"srgn", "--completions")
  end

  test do
    assert_match "H____", pipe_output("#{bin}/srgn '[a-z]' '_'", "Hello")

    test_string = "Hide ghp_th15 and ghp_th4t"
    assert_match "Hide * and *", pipe_output("#{bin}/srgn '(ghp_[[:alnum:]]+)' '*'", test_string)

    assert_match version.to_s, shell_output("#{bin}/srgn --version")
  end
end
