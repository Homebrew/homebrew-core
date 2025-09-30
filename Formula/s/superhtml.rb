class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "6b6938446b86478608df954755ba0d212e6d2defb4b12d64395c79a091d9c087"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5a88ab418b32a50ca3389a0adbf6d655aebd8dc6b4680a2e9eefa47411e28ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16805618a92e9cb64d33ddf5e556ed38b5bedd0c76d930f9b80d67fc2d0871cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4b555ecd2f36c8e2514b9f81cc97c3e3e1771fbd64af0dcd82cfb6059208ce1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a762440b5e8dd1a9827d9f40a64f640ab4ab2a458013e2257f7bf92e9b189c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d67bc6aaab0d15a7892915ed6dbf533162f0906be46b432f17d2a42f585b22f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6b03aae0c1bbd1b9f29ea0061b8a0f25981c5b7afc8ff9708c96e6f98a461e"
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
