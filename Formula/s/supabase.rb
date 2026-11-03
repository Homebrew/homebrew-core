class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "bf04fcd8ce0240d258ec0f9c72aaedb4cbabb54172a87cac82740bee4723cbf7"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "898bcddff939a72e179afc00c0d76d4fa13d9610471a32da5d78de59b25fe408"
    sha256 arm64_tahoe:       "be93f61215970cabd516a0346c49ac7586486b8c4e3f840d70eddc96d640bac3"
    sha256 arm64_sequoia:     "8968f5c97a9a2aa0a4e41d0986d7f006b28e477813415b85dd100d1732a0f2ee"
    sha256 arm64_linux:       "82e96a1b65e607933149f04132438d4399de9a248df96f8b99da505e68adabcc"
    sha256 x86_64_linux:      "b8c9930d617626184ddd0893f9e65cdec56686c2f4746ec0ac6187e1f970f91c"
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
