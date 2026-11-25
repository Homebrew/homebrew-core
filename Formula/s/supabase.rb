class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "07df917b082137497f14961a67a8fb73494c7ac4accad923307a9aee471c6dd1"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "3f7c30caa8dc022b851e7e698cd09cb0a42f8af56e0f84a0608049b5ba7e7148"
    sha256 arm64_golden_gate: "020e472b19b6e8a59486e82fe2f3f2ec2d48c0529f416251335e4ee1bdbad48a"
    sha256 arm64_tahoe:       "e02b9cf7f84346bf458ad2e21112c63ab1a05ee66e328b631d52f60942c466d7"
    sha256 arm64_sequoia:     "3eb10d15e2c37eea48409d56b7574a7c3c0b62af59b782aa182be567a4a5cd21"
    sha256 arm64_linux:       "b9cc9d2aaf286a376df8a38072b073a841beedd5d85a2842cbd904027a22e7b5"
    sha256 x86_64_linux:      "fbd496df7efe09a291ceda4ecb3b51aca1b4e534d7d44dff9f02e6e8398c9119"
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
    assert_path_exists testpath/"supabase/config.jsonc"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
