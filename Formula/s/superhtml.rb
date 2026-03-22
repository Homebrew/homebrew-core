class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "431d7189501e1b2e8da53c3ca8d6e7f1c642b523f3715c21cb8bfd2f8eef3971"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ecdeda20aba3c932e654ce1a7ad91174f5084cc83633c5d9cd6f1390daee912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8012a4daf05ee0ddbb51d09172fadeb4fe23b21cadeed03a42c1663964bd52dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bae9719b4bb4567edaf1678911be594bfdc8d537996bb723f300c3fb0f2aad93"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41742a7a7b61ce1e6bf019e897ae0b3f0076215353a8af4b7f53750533593f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b468973d40b401cf79782c7b85cf42696046c5064797af71a24de169e5b33d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8874ee426039b691bb1faffd504ba20c22be4501f249d0bf8f84f2f46c636f5f"
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
