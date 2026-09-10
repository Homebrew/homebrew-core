# CANDIDATE ONLY — not validated with `brew install --build-from-source` / `brew test` /
# `brew audit`, which cannot run in the sandbox (read-only /opt/homebrew).
# Keep the existing `bottle do` block from the current formula; BrewTestBot updates it.

class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://github.com/supabase/cli/archive/refs/tags/v2.117.0.tar.gz"
  sha256 "630de8f7edba860d85a4ca303731241bf7ae96267c00d99a7f7d0496164cee1c"
  license "MIT"
  head "https://github.com/supabase/cli.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_releases
  end

  depends_on "bun" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"

    # plpgsql-deparser imports @libpg-query/parser without declaring it, which pnpm's
    # global virtual store cannot resolve. Upstream bug; link it in rather than patching
    # pnpm-workspace.yaml, which would invalidate the lockfile.
    deparser = (buildpath/"node_modules/.pnpm/node_modules/plpgsql-deparser").realpath
    parser = (buildpath/"node_modules/.pnpm/node_modules/@libpg-query/parser").realpath
    (deparser/"node_modules/@libpg-query").mkpath
    ln_sf parser, deparser/"node_modules/@libpg-query/parser"

    # The tag archive carries a placeholder version; upstream inject the real one at release.
    system "bun", "apps/cli/scripts/sync-versions.ts", "--version", version

    libexec.mkpath
    ldflags = "-X github.com/supabase/cli/internal/utils.Version=#{version}"
    cd "apps/cli-go" do
      system "go", "build", *std_go_args(output: libexec/"supabase-go", ldflags:)
    end

    cd "apps/cli" do
      system "bun", "scripts/build-binary.ts"
      libexec.install "dist/supabase-legacy" => "supabase"
    end

    # `bun build --compile` injects its payload into a copy of the `bun` executable without
    # re-signing, leaving a stale signature that macOS SIGKILLs at launch.
    if OS.mac?
      %w[supabase supabase-go].each do |binary|
        system "/usr/bin/codesign", "-f", "-s", "-", libexec/binary
      end
    end

    # supabase-go must stay next to the shell binary: it is resolved relative to
    # process.execPath (apps/cli/src/shared/legacy/go-proxy.layer.ts).
    bin.install_symlink libexec/"supabase"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
