class Urx < Formula
  desc "Extracts URLs from OSINT Archives for Security Insights"
  homepage "https://github.com/hahwul/urx"
  url "https://github.com/hahwul/urx/archive/refs/tags/0.9.0.tar.gz"
  sha256 "a0e711229d26dc88682d383b656c8e2eb17a63b8316a94f1b69c090e79ea43cd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "865f128ab19987d17236c1555768a52dcc5e5372a4440311b8e5f6713f1099c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36cc8d2ead79e4aa553b4ecee1fe09329a0030bb4aac954cb409121492f27a39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49aee02616032da6bf8bd44d807e865aee40b33a8c0c18d7b0fe22f4fa3d9923"
    sha256 cellar: :any_skip_relocation, sonoma:        "9460b73fd81f82ba9000d80736b1a55c2199e8356f91ea3c36cbde4e8b95157e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b714988c3733c987a0c3178f8b6efba31f683c704f89b20efdd0ba9988e28d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8eaf1b6bfe9e371e1005a9659125ecf545cb6c18dfbee03d0a853d355da240fb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "urx #{version}", shell_output("#{bin}/urx --version")
    assert_match "https://brew.sh/", shell_output("#{bin}/urx brew.sh --providers=cc --include-sitemap")
  end
end
