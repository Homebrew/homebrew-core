class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "24edf6a6afd349e92c5cdf62324e783be822db24b1402024f2ff38ddfac7b25b"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "171ea4b11bd151b5d782a205fae112ca1afef063c515908e8fd2ba263cda1f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "370a5fedafb35076160fa8f45d09f9da49fca46824bef757f810091ef56ec5ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cce23f9a2275d9e50e7aee7370e477b4e57d72da7979a12a03ca32714ab4477"
    sha256 cellar: :any_skip_relocation, sonoma:        "df658ab24b4598f270f746a68c965708af53f3a36261340ac17f3ed5e965c398"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb7d38dadac2efa4cf8922f9eb1f608b20e77a4400433eda595ec02d4ad0bd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd1cf3973c7f0509f4e437c9b4ce86c86a801bbfa34a4885d106b65d9605ef84"
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
