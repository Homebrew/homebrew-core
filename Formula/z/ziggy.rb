class Ziggy < Formula
  desc "Data serialization language for expressing clear API messages, config files, etc"
  homepage "https://ziggy-lang.io"
  url "https://github.com/kristoff-it/ziggy/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "d3eff849a43a379740990aa4004368dbd7339344caa24bd7bf384e11733196df"
  license "MIT"
  head "https://github.com/kristoff-it/ziggy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f257bf69db05e9f786c5e7dcfe340ea03d1314381f878eb8e487291978ab2ab8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f1569054c3191f2bb6172a73a277d1c03f5a02b1e7d26822898562be692667e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "367a02639d2acbc3265fb2cec9686d5a767568ec162d214b954a5d869bd6f037"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a2ee7eb71666b250ac2703dbe6c0dd85bca5762d688adcdccb0ba337e77170c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "df909b7972fe67b02fcfb324f3c58bbf040aa3231cbcb857995adbe9e80a9b8b"
  end

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ziggy version 2>&1")
    (testpath/"test.ziggy_schema").write <<~ZIGGY_SCHEMA
      $ = Root

      struct Root {
          a: bool,
          b: int,
      }
    ZIGGY_SCHEMA
    (testpath/"test.ziggy").write <<~ZIGGY
      .a = true,
      .b = 1,
    ZIGGY

    system bin/"ziggy", "check", "--schema", "test.ziggy_schema", "test.ziggy"
  end
end
