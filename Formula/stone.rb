class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "https://www.gcd.org/sengoku/stone/"
  url "https://www.gcd.org/sengoku/stone/stone-2.4.tar.gz"
  sha256 "d5dc1af6ec5da503f2a40b3df3fe19a8fbf9d3ce696b8f46f4d53d2ac8d8eb6f"

  livecheck do
    url :homepage
    regex(/href=.*?stone[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4274010ee7d7f736080d17b23ee12250fc7f68a530c9149a0a625922a9db1bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a2008041ad4e5e76fe87a4218d4c21e5b1a2cea828aa97b9e9e5b6c6ecc882"
    sha256 cellar: :any_skip_relocation, monterey:       "dc89da0846364ce236eed2a2cfe0eb39abd9dc71f42f3b357d6a5709efb025d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f943cab7f931ae2b7c124a83b63150b9c3b75090eb63353fbe0732792b97a0bf"
    sha256 cellar: :any_skip_relocation, catalina:       "cadf40dd1d8aa5de47b9d3d3baa5bbc22fc5a8a50abe688e77520b035369f492"
    sha256 cellar: :any_skip_relocation, mojave:         "13be210aea90ed4b9067afcf0dcad8e54494c0f262aa94fb51f926f7a46b8e27"
  end

  def install
    system "make", "macosx"
    bin.install "stone"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stone -h 2>&1", 1)
  end
end
