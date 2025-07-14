class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.6.6.tar.gz"
  sha256 "3b2f5260813131670840f142676a01a8eba22064bd8f552561fd31c9ba16bb68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65c002d60b8d19f4555ee0a3c4e6eddf72a4278085b36f4cde1069af415b4f34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfabac7f5b9080b178f8706edf3816697b9ac8926f11316d9d7fa852b1601003"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abfbdd2d64738f8266da31aa38e0f982b67b6df6b1f4ecefdeee685fef769aa7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5c37dd63f4f266715597925b34ef433593d9c45e8f5eca8e9c1ff9d064e1b8a"
    sha256 cellar: :any_skip_relocation, ventura:       "a4ac29056e3d880be60edad95495d3b72d57c05314886b41d830c5e01d800162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a97e98f125560ed08a601a7fd280d03534510f787a7491e08aa7730be0843bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f388d3eabb197df201e11d4ce023af348286b88933341aa903df738e94a37417"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_path_exists testpath/".xwin-cache/splat"
  end
end
