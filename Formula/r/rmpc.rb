class Rmpc < Formula
  desc "Terminal based Media Player Client with album art support"
  homepage "https://mierak.github.io/rmpc/"
  url "https://github.com/mierak/rmpc/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "c0dca5f4be1222591a69b82e77d6fe42df259e6130ea7ea7dd6372515b5f4357"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff50b373be90373b9e3b18d0ec63c0be8a58b0e813ad685b97e664d56115d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "628e740ddb130cc457f3aa22c222c6a86fb7bdcea61b54e5d1b93e50d03f0c4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f309a228aa4affad8f4581942f7201b45000891db2a6411e67e8c5bab93f60fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44b890cbdb18fa990bd3ad3ec2eb2250f7600b9dcab0c1870c96023e77a25acf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b96a2bbf4cc69d44711769f593f98339e71115b406f31482724b24d8fb2c3c20"
    sha256 cellar: :any_skip_relocation, ventura:       "3545dd59252302959d7f43ca65fdc00b059691172680f27914d99ede9c77d821"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f020ec622900283a52792838aa3429d6c3cc83c857b0a99e9da04e041873ac32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b0f1327ee81b5074ecb363855443f745260cccb09c1fb2e6b1dfa18d4c95f48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/#!\[enable/, shell_output("#{bin}/rmpc config"))
  end
end
