class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "f5256ecffb04015e9b9a213c1f2470530d3dc7df34811a2872c48982ec3d451f"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "9d59753bbc4a916e0b8d150bd1cef8a55f8d374f8780d8ac9b7811c5968aa639"
    sha256 arm64_tahoe:       "0ba89d3384b9bec4f0784284eb97fc4a7b03946b60005ef215eb24e258c1b437"
    sha256 arm64_sequoia:     "ad27af864845fe12b225b3c1f26f7f7f744ab40bb874f40a9cdd49b2523ef3e7"
    sha256 arm64_linux:       "c9e3d5bd44d31837afa8cca2b63332037a819dee5b35dc1394bc60048ff7e61d"
    sha256 x86_64_linux:      "435d62f6e162b4a7fe304c7275e9ec4c0bea9429a4453ab454bf0b5d00b2fa5a"
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
