class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "325b28bd5e8da316e319361f2dd8e3cc74fcd55724fc8ad4b2a73c21b2903bd8"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  # The leading `v` in this regex is intentionally non-optional, as we need to
  # exclude a few older tags that use a different version scheme and would
  # erroneously appear as newer than the newest version. We can't check the
  # "latest" release on GitHub because it's sometimes a lower version that was
  # released after a higher version (i.e., "latest" is the most recent release
  # but not necessarily the newest version in this context).
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "576cc3661197c7140e4f1e73f1136f2e48588485aeb20625704358acca2e8802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0533a4c02c2376d7e5d41a529de7519be4092d4c66b4ad66cfd4cd277fb1fc6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61e6682d7f0a226d7f0a58d29540c30caf07f6cc49ed243bdde5a8e64f238dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa7ba93c9e1de2091f5aa809bc772e383160c14bc1c53fc623be305ebb8053a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "875458d3eafd19ab0490d73130dc93e75e09c6080dbd65080855b2b53dad6bb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a2adca7bf767eb1385fb51fbbbab3ec42b048ec1d4e839fea1f8c9248a07a9f"
    sha256 cellar: :any_skip_relocation, ventura:        "98268b0618e3050e2082400d38ff4ae366804775eca808f01984036611e4f3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "ae3ceae715d522bfedb2ddb04f15e80b4049b8e55d4c08290ab4fa6272c0ab96"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c7051f4493387b915de7035c592383bc6795aa91af876dc2873994b9c879bae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5cf84272a6a20e77a2c2e198bdaa103204b0b104a00b6fa7f16a026455b7225"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
    system "make", "install-docs", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less .")
    assert_match "Hello from", output
    assert_match "Homebrew", output
  end
end
