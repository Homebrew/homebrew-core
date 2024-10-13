class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https://enter-tainer.github.io/typstyle/"
  url "https://github.com/Enter-tainer/typstyle/archive/refs/tags/v0.11.35.tar.gz"
  sha256 "aac4abdd6d7f24321d34b43b8684bc64dba7faad964a2159fcb8842387de0e87"
  license "Apache-2.0"
  head "https://github.com/Enter-tainer/typstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e95bc9fdffaa7329ac240994078905c261bf9091e1fd53752ab24a44ee93212b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58e226d4939590acdc8c7cb4aada26d4f7533d91679051eb0668cebe61519e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71b89e1d8c8e05e497bf47cdf2129d9dfa1ad6ffd7ef9cc043de20be7dd9ecb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "91fb1029d66007ffe74ab43a4e8ae06464f12f3a11a726354159b37beae16553"
    sha256 cellar: :any_skip_relocation, ventura:       "83c1ac2206424e29b5c37763e728bcc19f72203d77d1fab8641769fcebe9559f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cd6243350f7aa87a7e7b5b616d648b9d561951e6efc8048204ddb6b55fa400a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typstyle --version")
  end
end
