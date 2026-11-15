class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "a5092f06540749eb7e29025651e8f9c59819b6e8a574f7a13ebccb01243c2a32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f732d36799b5cf8266aa082a4068b42394e343be5adccf62b18153caba76aa9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1012d715d16b4ee40dec42a806c81cfa4ee95abde83b96c51fb24d1e4ce02f8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b1825c82f70d7eabfe05296d6ed53fed4ac06cdcf367da3af50fb90b9c55be3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ddba2ecc25ab24ad140dfea8e3bb6dbe62853c747c786c26accce1e69423a9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "31a6d7a3b3df3b5538e4f384a9fac0254ac60cb3878cdef455bb3b13deec9bd6"
  end

  depends_on "zig" => :build

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch"
  end

  def install
    # upstream issue: https://github.com/kristoff-it/superhtml/issues/108
    inreplace "build.zig", '"unknown"', "\"#{version}\"" # patch fallback version

    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superhtml version 2>&1")

    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    HTML
    system bin/"superhtml", "fmt", "test.html"
  end
end
