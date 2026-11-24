class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https://www.getzola.org/"
  url "https://github.com/getzola/zola/archive/refs/tags/v0.23.6.tar.gz"
  sha256 "193db594222cd9c1097387ce17272cbbe672c3a894c263f6f4c436a7fedb379f"
  license "EUPL-1.2"

  bottle do
    rebuild 1
    manifest_sha256 "4cb11e05d47a2454940effe730c3f3f6fad7a919d0deff7dc0702f878b632385"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25a358005824b7a80415cf9db563ef19ed7586b35a641030c0b847a613c8b854"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "62df16c7c0498224e9627eea2cc45377f9340f01e7dbd9c4e96ddc647e720f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8c3dac8098282cb1aa5c6c2f54725e6c77f0158fc4c22a85201864aa85c23e6f"
    sha256 cellar: :any,                 arm64_linux:       "0dfc5cace092436085a47d97070c9df3e87ffc6e902bba925393bab4370e5888"
    sha256 cellar: :any,                 x86_64_linux:      "9d028f5c1607a75666f6975f7ae2236a72b90e2c646727ddbd8abb600ebaf22e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    # Bump `giallo` which depends on deprecated `oniguruma`
    # upstream commit: https://github.com/getzola/zola/commit/88deaf202b3aca0073c7094d604bf8ee1831becf
    odie "Remove `giallo` workaround" if version > "0.23.6"
    inreplace "Cargo.toml", 'giallo = {version = "0.5", features = ["dump"]}',
                            'giallo = {version = "0.6", features = ["dump"]}'
    system "cargo", "generate-lockfile"

    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zola", "completion")
  end

  test do
    system "yes '' | #{bin}/zola init mysite"
    (testpath/"mysite/content/blog/_index.md").write <<~MARKDOWN
      +++
      +++

      Hi I'm Homebrew.
    MARKDOWN
    (testpath/"mysite/templates/section.html").write <<~HTML
      {{ section.content | safe }}
    HTML

    cd testpath/"mysite" do
      system bin/"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.</p>",
      (testpath/"mysite/public/blog/index.html").read.strip
  end
end
