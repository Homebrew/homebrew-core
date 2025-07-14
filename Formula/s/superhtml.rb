class Superhtml < Formula
  desc "HTML Language Server & Templating Language Library"
  homepage "https://github.com/kristoff-it/superhtml"
  url "https://github.com/kristoff-it/superhtml/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "e1e514995b7a834880fe777f0ede4bd158a2b4a9e41f3a6fd8ede852f327fe8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fee37c33e1945e1b65754df3584ac9f9460e612c1465cb7a8c99a7fd4320545d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03ab9a454ac7aaca7371a477f80d49f0fe0f7029747e4041332b13a3d00cf534"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d23e940a93d67b167a7f581c1558eb2c8576c94c3d9e0acfa0772fde7f36a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eff6f7d3a54c0286b29a347c69d4aedf8d685eb28e48eb8dbf1c4aa82db437b"
    sha256 cellar: :any_skip_relocation, ventura:       "59b688fbedae2f2e86cad38aff7ced5f84757c8986151abb42c7bbfd86fe78b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e298e19fd4b396615ccfd7939ab11dba25d2668533b4e9a3324f0207b027ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ffcd873d33cbb738fda0172a485473d7d2f5bf7c0b642b7c7ae93e840daa98f"
  end

  depends_on "zig" => :build

  # Backport dependency updates to cleanly apply Zig 0.14 commits
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/0c65d59dad108eaa7869e70b67a1783d4c7f5ba4.patch?full_index=1"
    sha256 "9312c6bae69ebbef9b2430fb36a3623d907ed3ea59649c93b592e1f6969e0e35"
  end
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/1d4fbe06aa056a5858d3fdcf33e5ec001f44f6ea.patch?full_index=1"
    sha256 "78531ca8fc22e1f9936e6f0017073c4f143591d70fefffcdb335cbcb346ff5b9"
  end
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/9266b3131bbcc0705b3b752bcb7478871a143740.patch?full_index=1"
    sha256 "efec7fa00e2094fdd69e6ec7d49ec6e26a355ad45f9f8079f16aae1a9eb84ca3"
  end

  # Backport commits to build with Zig 0.14
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/44abb10a4b28b8b66710e8d4a56aa897b52c11a5.patch?full_index=1"
    sha256 "8e98cd7d14a281e9269517d710e02cd2a0c074c56b7d64469148b49b686f1a92"
  end
  patch do
    url "https://github.com/kristoff-it/superhtml/commit/848947947a3312dfe9b88a1976f8a6bc4804d316.patch?full_index=1"
    sha256 "1ec6acde9d78d58ca36d61a5fb5ff8490f2ed56db8008755860aaab128e182ac"
  end

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case ENV.effective_arch
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else ENV.effective_arch
    end

    args = %W[
      -Dforce-version=#{version}
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
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
