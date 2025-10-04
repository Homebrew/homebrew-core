class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "e84b0f4c95187561c16d216fb520c1fb7362b4d8f0ff1cec8d4a3694fbd379b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b4f35421ec563af57470210c14dbda4a8e9050dc6b246775c64656850d9d832"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf7687da152f5b98daeb631869096b1cee93283369bb78a414315fa72bae19a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b479060507e35d2ab4c92b1909764f48fc2a7acd017c5d7a6374684d4ef6876b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5273aa27979d30a8c4d2b0151d177d30109d4ec3b28dec2338295abbf8f1f827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e77396abe94918e3af64ff87b0c37581743089cdbbb27ec1ad3a6e6bedc60691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b116b12b4d104a638425ba9d23c1bb800d93c738f9d45cbafdf2404c22c7d08"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    # upstream issue: https://github.com/kristoff-it/superhtml/issues/108
    inreplace "build.zig", '"unknown"', "\"#{version}\"" # patch fallback version
    args = ["-Dcpu=#{cpu}"] if build.bottle?

    system "zig", "build", *args, *std_zig_args
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
