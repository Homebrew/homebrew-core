class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "febeca291130664ab6ac004675edbb9cfe6fd6cb4c12fb2fd78b81c980448f72"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "678930697b2b19a5985af2bb829a5c71bbc93d7099ed70823e72e68aad8fa19f"
    sha256 arm64_golden_gate: "05db49dda92e9dc6fb408005979585dac4b9eb3d0d0ef9d67dd44454a3044e14"
    sha256 arm64_tahoe:       "48c266a4a28460bf22318cd10045cf448b64627ec6c910c14ab2852ebef8038a"
    sha256 arm64_sequoia:     "7ad32c6ad740c0e2b948cd258d639e75fb940974f8ff18b7e48f5372525fc8a7"
    sha256 arm64_linux:       "b8d0e73e7d1bf54baf9cd17837b4372fba55321c3723de1cece56e730b60be8d"
    sha256 x86_64_linux:      "0367bc783af8aab0a5685fe27517c9ad755256491100ece72ccfb106ae647c07"
  end

  depends_on "bun" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  on_linux do
    depends_on "icu4c@79"
  end

  deny_network_access!

  def fetch
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
  end

  def install
    # plpgsql-deparser imports @libpg-query/parser without declaring it, which pnpm's
    # global virtual store cannot resolve. Link it in rather than patching
    # pnpm-workspace.yaml, which would invalidate the lockfile.
    deparser = (buildpath/"node_modules/.pnpm/node_modules/plpgsql-deparser").realpath
    parser = (buildpath/"node_modules/.pnpm/node_modules/@libpg-query/parser").realpath
    (deparser/"node_modules/@libpg-query").mkpath
    ln_sf parser, deparser/"node_modules/@libpg-query/parser"

    # The tag archive carries a placeholder version; upstream inject the real one at release.
    system "bun", "apps/cli/scripts/sync-versions.ts", "--version", version.to_s

    cd "apps/cli" do
      system "bun", "scripts/build-binary.ts"
      bin.install "dist/supabase"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
